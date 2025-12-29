# Trek - Fitness Tracking App

Trek is a Strava-like fitness tracking application for iOS that helps users track their outdoor activities including running, cycling, hiking, and more.

## Features

- Real-time GPS tracking with map visualization
- Support for multiple activity types (running, cycling, hiking, etc.)
- Activity history and statistics dashboard
- Route recording with elevation tracking
- Performance metrics (distance, duration, speed, calories)

## Requirements

- iOS 17.0 or later
- Xcode 15.0 or later
- Swift 5.9 or later
- macOS Ventura or later (for development)

## Setup Instructions

### Creating the Xcode Project

Since this repository contains source files but not an Xcode project file, you'll need to create one:

1. **Clone the repository:**
   ```bash
   git clone https://github.com/zqang/trek.git
   cd trek
   ```

2. **Create a new Xcode project:**
   - Open Xcode
   - Select "Create a new Xcode project"
   - Choose "iOS" → "App"
   - Product Name: `Trek`
   - Team: Select your team
   - Organization Identifier: `com.yourcompany` (or your preference)
   - Interface: SwiftUI
   - Language: Swift
   - Storage: SwiftData (optional)
   - Click "Next" and save in the repository root

3. **Add the source files:**
   - Delete the default `ContentView.swift` and app file created by Xcode
   - In Xcode, right-click on the Trek folder in the project navigator
   - Select "Add Files to Trek..."
   - Select all the Swift files and folders from this repository:
     - `TrekApp.swift`
     - `ContentView.swift`
     - `Core/` folder
     - `Features/` folder
     - `Data/` folder
     - `Services/` folder
   - Make sure "Copy items if needed" is unchecked
   - Click "Add"

4. **Configure Info.plist:**
   - Select your project in the navigator
   - Select the Trek target
   - Go to the "Info" tab
   - Add the location permission keys from `Resources/Info.plist`:
     - `NSLocationWhenInUseUsageDescription`
     - `NSLocationAlwaysAndWhenInUseUsageDescription`
   - Go to "Signing & Capabilities" tab
   - Add "Background Modes" capability
   - Enable "Location updates"

5. **Configure deployment target:**
   - In project settings, set the iOS Deployment Target to iOS 17.0 or later

### Running the App

1. Open the Trek Xcode project
2. Select a simulator or connected device (iOS 17.0+)
3. Press `Cmd+R` or click the "Run" button
4. Grant location permissions when prompted

### Building from Command Line

For CI or command-line builds:

```bash
# Build for iOS Simulator
xcodebuild -scheme Trek -destination 'platform=iOS Simulator,name=iPhone 15' build

# Run tests
xcodebuild -scheme Trek -destination 'platform=iOS Simulator,name=iPhone 15' test
```

## Project Structure

```
trek/
├── TrekApp.swift              # App entry point
├── ContentView.swift          # Root view
├── Core/                      # Core utilities and configurations
│   ├── Constants.swift        # App constants
│   └── Theme/                 # Theming system
│       └── Theme.swift
├── Features/                  # Feature modules
│   ├── Dashboard/             # Dashboard feature
│   │   └── Views/
│   ├── Tracking/              # Activity tracking feature
│   │   └── Views/
│   └── Activities/            # Activities history feature
│       └── Views/
├── Data/                      # Data layer
│   └── Models/                # Data models
├── Services/                  # Services (Location, etc.)
└── Docs/                      # Documentation
```

## Architecture

Trek follows the MVVM (Model-View-ViewModel) architecture pattern. For detailed information, see [ARCHITECTURE.md](Docs/ARCHITECTURE.md).

## Development

### Code Style

- Follow Swift API Design Guidelines
- Use SwiftUI for all UI components
- Maintain clear separation of concerns (MVVM)
- Write descriptive comments for complex logic
- Use meaningful variable and function names

### Testing

Testing infrastructure to be added in future iterations.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Roadmap

- [ ] Enhanced activity statistics and analytics
- [ ] Social features (sharing activities, following friends)
- [ ] Route planning and discovery
- [ ] Apple Watch companion app
- [ ] Health app integration
- [ ] Workout audio coaching
- [ ] Custom activity types
- [ ] Export to GPX/TCX formats

## Support

For issues, questions, or contributions, please use the GitHub issue tracker.

---

Made with ❤️ for fitness enthusiasts
