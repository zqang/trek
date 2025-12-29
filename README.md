
# Trek

Trek is a Strava-like fitness tracking iOS app (MVP). This repository contains an initial SwiftUI + SwiftData scaffold targeting iOS 17+.

## What’s included
- SwiftUI skeleton (Dashboard, Record, Activities)
- Minimal SwiftData models (Activity, RoutePoint)
- Minimal LocationService (Core Location wrapper)
- MapKit integration placeholders
- Info.plist snippet for location permissions
- CI workflow placeholder

## Requirements
- Xcode 15+
- iOS 17+
- Swift 5.9+

## Quick setup
1. Open Xcode and create a new iOS App (SwiftUI) or add these files into an existing Xcode project.
2. Add the provided source files into the project target.
3. Add the Info.plist keys (see Resources/Info-Location.plist) to your app's Info.plist.
4. Build & run on device for location/GPS behavior (simulator offers limited location support).

## How to commit locally & open PR
1. Ensure `main` branch exists (create if needed).
2. Create feature branch:
   git checkout -b feature/init-ios
3. Add files, commit, push:
   git add .
   git commit -m "chore: initial iOS scaffold (SwiftUI, SwiftData, LocationService)"
   git push -u origin feature/init-ios
4. Open PR (GitHub UI or gh CLI):
   gh pr create --base main --head feature/init-ios --title "Set up initial iOS project structure for Trek fitness tracking app" --body "<paste PR body from PR_DESCRIPTION.txt>"

## PR checklist
- [ ] Project structure added
- [ ] SwiftUI skeleton views added
- [ ] Data models added (SwiftData)
- [ ] LocationService added
- [ ] Info.plist permission keys documented
- [ ] CI workflow added

## License
TBD
