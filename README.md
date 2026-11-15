# Would You Rather

An offline-first iOS game built with SwiftUI. Players choose between two playful scenarios, then discover which choice was more popular.

## Status

The project is being developed in reviewable batches. The current batch establishes the iOS application foundation, local models, navigation shell, test targets, CI workflow, and a placeholder backend workspace.

## Requirements

- Xcode with the iOS 17 SDK or later
- iOS 17 or later
- Node.js 20 or later for the backend workspace

## Run the iOS app

1. Open `WouldYouRather.xcodeproj` in Xcode.
2. Select an iPhone simulator running iOS 17 or later.
3. Run the `WouldYouRather` scheme.

## Project layout

- `WouldYouRather/` — SwiftUI application source
- `WouldYouRatherTests/` — unit tests
- `WouldYouRatherUITests/` — UI tests
- `backend/` — future Cloudflare Worker and D1 backend

## Security

The iOS app never contains AI provider secrets. Future Gemini credentials belong only in backend environment variables such as `backend/.dev.vars`, which is intentionally ignored by Git.

## Development workflow

Each implementation batch is developed on a dedicated branch and submitted for review as an individual Pull Request. No batch is merged automatically.
