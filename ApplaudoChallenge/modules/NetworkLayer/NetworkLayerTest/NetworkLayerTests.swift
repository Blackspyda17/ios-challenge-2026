import Combine
import XCTest
@testable import NetworkLayer

/// Stub a mano: devuelve lo que le pongamos, sin Moya de por medio.
private struct StubRequester: NetworkingRequesterType {
    let result: Result<Data, NetworkError>

    func execute(request: NetworkingTargetType) -> AnyPublisher<Data, NetworkError> {
        result.publisher.eraseToAnyPublisher()
    }
}

final class CatBreedServiceTests: XCTestCase {
    private var bag = Set<AnyCancellable>()

    private let twoBreeds = """
    [
      {"id":"abys","name":"Abyssinian","description":"Active cat","temperament":"Active, Smart","origin":"Egypt","life_span":"14 - 15","reference_image_id":"0XYvRd7oD",
       "image":{"id":"0XYvRd7oD","url":"https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg","width":1204,"height":1445}},
      {"id":"aege","name":"Aegean","origin":"Greece","life_span":"9 - 12"}
    ]
    """.data(using: .utf8)!

    func testSuccessDecodesBreeds() throws {
        let exp = expectation(description: "breeds")
        var got: [Breed] = []

        CatBreedService(requester: StubRequester(result: .success(twoBreeds)))
            .breeds(limit: 10, page: 0)
            .sink(receiveCompletion: { _ in exp.fulfill() },
                  receiveValue: { got = $0 })
            .store(in: &bag)

        wait(for: [exp], timeout: 2)
        XCTAssertEqual(got.count, 2)
        XCTAssertEqual(got[0].name, "Abyssinian")
        XCTAssertEqual(got[0].imageURL?.absoluteString, "https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg")
        XCTAssertNil(got[1].imageURL) // sin imagen ni reference id
    }

    func testServerErrorPassesThrough() {
        let exp = expectation(description: "500")
        var code: Int?

        CatBreedService(requester: StubRequester(result: .failure(.serverError(statusCode: 500, data: Data()))))
            .breeds(limit: 10, page: 0)
            .sink(receiveCompletion: {
                if case .failure(.serverError(let c, _)) = $0 { code = c }
                exp.fulfill()
            }, receiveValue: { _ in })
            .store(in: &bag)

        wait(for: [exp], timeout: 2)
        XCTAssertEqual(code, 500)
    }

    func testGarbageJSONMapsToDecodingFailed() {
        let exp = expectation(description: "bad json")
        var didFail = false

        CatBreedService(requester: StubRequester(result: .success(Data("{oops".utf8))))
            .breeds(limit: 10, page: 0)
            .sink(receiveCompletion: {
                if case .failure(.decodingFailed) = $0 { didFail = true }
                exp.fulfill()
            }, receiveValue: { _ in })
            .store(in: &bag)

        wait(for: [exp], timeout: 2)
        XCTAssertTrue(didFail)
    }
}
