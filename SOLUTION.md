# SOLUTION.md — Cat Breed Explorer

## How to run it

1. Get a free API key from https://developers.thecatapi.com/ and paste it in
   `modules/NetworkLayer/Sources/Networking/Configuration/NetworkingTargetType.swift`
   where it says `"x-api-key": "YOUR-API-KEY"`. Without the key the app still
   opens but the list shows its error state with retry (I tested this).
2. `tuist install && tuist generate` (with tuist 4.200.x the command is
   `install`; the README says `fetch`, which was for older versions).
3. Open `ApplaudoChallenge.xcworkspace` in Xcode 26+ and run on simulator.

## Architecture

Classic MVVM with Combine, which is what the challenge asked for and what
the `NetworkLayer` already expected (publishers). Each screen has its
ViewModel (`ObservableObject` + `@Published`), the service is injected via
`init` with a real default to keep views simple, and views just draw state.
I didn't add coordinators or Clean architecture with use cases: for two tabs
it felt like over-engineering and I preferred small, readable files.

- `Breed` / `BreedImage`: only the fields I use (`id`, `name`, `description`,
  `temperament`, `origin`, `life_span`, `reference_image_id`, `image`). The
  rest of the payload is ignored. `imageURL` prefers the embedded image and
  if there's none it builds the CDN URL with `reference_image_id`, because
  several breeds come without `image`.
- `CatInformationTarget.listBreeds(limit:page)`: extends the example target
  with query params. I didn't touch the requester, just made
  `NetworkingTargetType`, `NetworkingRequester(Type)` and `RequestMethod`
  public because otherwise the service couldn't live outside the module.
- `CatBreedService`: exposes `breeds(limit:page:) -> AnyPublisher<[Breed],
  NetworkError>`, with `receive(on: main)` so ViewModels don't worry about
  the thread.
- Persistence: `MyCatStore` saves `[MyCat]` as JSON in UserDefaults. I
  thought about SwiftData but for a small personal list it was more risk
  than benefit (migrations, container in the App, iOS 17+). It survives
  restarts, which was the requirement.
- DI/SOLID: ViewModels receive protocols via `init` (`CatBreedServiceType`),
  each type has a single reason to change, and there are no singletons
  except the unique `MyCatStore` instance created in the App (composition
  root) and injected downward — no View touches globals.

## Screens

- **List (S1+S4)**: `BreedsListView` + `BreedsListViewModel`. States
  loading/empty/error with `EmptyStateView`, pull-to-refresh, and pagination
  of 10 per page that triggers when getting close to the end (window of 3).
  The first page defines the global state; subsequent ones add without
  clearing, and if a page fails the list stays visible with a retry below.
- **Detail (S2)**: photo with `AsyncImage` (with placeholder if none),
  full description, origin, temperament and life span. Navigation with
  `NavigationStack`, the back button comes for free.
- **Form (S3+S5)**: `AddCatView` in 3 steps with `StepperIndicator` (basic
  → details → review). Each step validates before advancing and errors show
  inline in `AppTextField`: name ≥3, breed required, age integer 1–30,
  description ≥10. On save, confirmation alert and option to add another.
- **My Cats**: Third tab that shows the cats registered by the user. Uses
  the same `MyCatStore`, so changes in the form tab reflect immediately.
  Empty state with `EmptyStateView` when no cats are registered yet.

Everything uses `AppTheme` and existing components; I only added small rows
(`BreedRow`, `FactRow`, `ReviewLine`) where there was no component.

## Trade-offs and assumptions

- The breed in the form is free text, not a picker from the catalog: it
  works offline and doesn't couple the form to the service. With more time
  I'd add autocomplete with the loaded breeds.
- Age is asked as text with numeric keyboard and parsed to `Int`; simpler
  than a numeric stepper and validates the same.
- Without an API key there's no real data: the error state makes it clear
  instead of a blank screen.
- The detail doesn't do an extra fetch per breed: `/breeds` already brings
  everything the screen shows, one less call.

## What I'd improve with more time

1. Disk cache for the first page + images (URLCache already helps with
   photos, but the list starts empty every time).
2. Local search by name/breed on what's already loaded.
3. Delete/edit my registered cats (the store already has `remove`).
4. Snapshot tests for the rows and UI test for the complete form flow.

## Tests

- `NetworkLayerTests`: success (decodes 2 breeds, one without image), 500
  error that passes as `.serverError`, and broken JSON that maps to
  `.decodingFailed`.
- `ApplaudoChallengeTests`: form validations (short name, invalid age,
  valid flow) and store round-trip with "restart".
- `xcodebuild build` and `xcodebuild test` green on both schemes.
