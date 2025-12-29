# Trek - Fitness Tracking App

Trek is a Strava-like fitness tracking iOS application built with SwiftUI. Track your runs, walks, cycling, and other activities with detailed metrics and GPS route recording.

## Features

- 📊 **Activity Dashboard** - View your weekly stats and recent activities
- 🏃 **Live Tracking** - Record activities with GPS tracking, distance, duration, and speed
- 📱 **Multiple Activity Types** - Running, cycling, walking, hiking, swimming, and more
- 🗺️ **Route Recording** - Save and visualize your activity routes with MapKit
- 📈 **Activity History** - Browse and review all your past activities

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## Getting Started

### Prerequisites

1. macOS with Xcode 15 or later installed
2. An Apple Developer account (for device testing)
3. An iOS device or simulator running iOS 17+

### Setup Instructions

Since this repository contains Swift source files without an Xcode project file, you'll need to create the Xcode project:

1. **Clone the repository:**
   ```bash
   git clone https://github.com/zqang/trek.git
   cd trek
   ```

2. **Create a new Xcode project:**
   - Open Xcode
   - Select "Create a new Xcode project"
   - Choose "iOS" > "App"
   - Product Name: `Trek`
   - Interface: `SwiftUI`
   - Language: `Swift`
   - Minimum Deployment: `iOS 17.0`

3. **Add the source files to your project:**
   - Delete the default `TrekApp.swift` and `ContentView.swift` files Xcode created
   - Drag and drop all the source files and folders from this repository into your Xcode project
   - Ensure "Copy items if needed" is checked
   - Add to targets: Trek

4. **Configure Info.plist:**
   - Merge the keys from `Resources/Info.plist` into your project's Info.plist
   - Or replace your Info.plist with the one from Resources/

5. **Enable background modes:**
   - Select your target in Xcode
   - Go to "Signing & Capabilities"
   - Click "+ Capability" and add "Background Modes"
   - Check "Location updates"

6. **Build and run:**
   ```
   Command+R or click the Run button
   ```

### Running in Xcode

1. Open the Trek project in Xcode
2. Select a simulator or connected device
3. Press `Cmd+R` to build and run
4. Grant location permissions when prompted

### Project Structure

```
Trek/
├── TrekApp.swift              # App entry point
├── ContentView.swift          # Root view with TabView
├── Core/
│   ├── Constants.swift        # App-wide constants
│   └── Theme/
│       └── Theme.swift        # Color and typography theme
├── Features/
│   ├── Dashboard/
│   │   └── Views/
│   │       └── DashboardView.swift
│   ├── Tracking/
│   │   └── Views/
│   │       └── TrackingView.swift
│   └── Activities/
│       └── Views/
│           └── ActivitiesListView.swift
├── Data/
│   └── Models/
│       ├── Activity.swift     # SwiftData activity model
│       └── RoutePoint.swift   # GPS route point model
├── Services/
│   └── LocationService.swift  # Location tracking service
└── Resources/
    └── Info.plist            # Required permission keys
```

## Usage

### Recording an Activity

1. Tap the "Record" tab
2. Select your activity type (Running, Cycling, etc.)
3. Tap "Start" to begin tracking
4. Use "Pause" and "Resume" as needed
5. Tap "Stop" when finished

### Viewing Your Dashboard

- The Dashboard shows weekly statistics including:
  - Total distance
  - Total duration
  - Number of activities
  - Calories burned

### Browsing Activities

- Tap the "Activities" tab to see all your recorded activities
- Each activity shows distance, duration, and calories

## Architecture

See [ARCHITECTURE.md](Docs/ARCHITECTURE.md) for detailed information about the project architecture and structure.

## Development Roadmap

- [ ] Implement SwiftData persistence
- [ ] Add detailed activity view with route map
- [ ] Add activity editing and deletion
- [ ] Implement activity stats and charts
- [ ] Add social features (share activities)
- [ ] Add goal setting and achievements
- [ ] Add Apple Health integration
- [ ] Add workout audio cues

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Built with SwiftUI and MapKit
- Inspired by Strava and other fitness tracking apps

## Support

For issues, questions, or contributions, please open an issue on GitHub.
