# Trek Architecture

## Overview

Trek is built using SwiftUI with the MVVM (Model-View-ViewModel) architecture pattern. The app follows a feature-based modular structure for better organization and scalability.

## Architecture Pattern: MVVM

### Model
- Represents the data and business logic
- Located in `Data/Models/`
- Uses SwiftData for persistence (iOS 17+)
- Independent of the UI

### View
- SwiftUI views that display the UI
- Located in `Features/*/Views/`
- Observes ViewModels using `@StateObject` and `@ObservedObject`
- Purely declarative

### ViewModel
- Mediates between Model and View
- Handles business logic and state management
- Uses `@Published` properties for reactive updates
- To be implemented in `Features/*/ViewModels/` as needed

## Project Structure

```
Trek/
├── TrekApp.swift                    # App entry point (@main)
├── ContentView.swift                # Root view with TabView navigation
│
├── Core/                            # Core utilities and shared code
│   ├── Constants.swift              # App-wide constants
│   └── Theme/
│       └── Theme.swift              # Design system (colors, fonts)
│
├── Features/                        # Feature modules
│   ├── Dashboard/                   # Dashboard feature
│   │   ├── Views/
│   │   │   └── DashboardView.swift
│   │   └── ViewModels/             # (To be added)
│   │
│   ├── Tracking/                    # Activity tracking feature
│   │   ├── Views/
│   │   │   └── TrackingView.swift
│   │   └── ViewModels/             # (To be added)
│   │
│   └── Activities/                  # Activities list feature
│       ├── Views/
│       │   └── ActivitiesListView.swift
│       └── ViewModels/             # (To be added)
│
├── Data/                            # Data layer
│   ├── Models/                      # Data models
│   │   ├── Activity.swift          # SwiftData activity model
│   │   └── RoutePoint.swift        # GPS route point model
│   └── Repositories/               # (To be added) Data access layer
│
├── Services/                        # Business services
│   ├── LocationService.swift       # GPS location tracking
│   └── ...                         # (More services to be added)
│
└── Resources/                       # App resources
    └── Info.plist                  # App configuration
```

## Key Components

### 1. App Entry (TrekApp.swift)
- Uses `@main` attribute as the app's entry point
- Creates the main `WindowGroup` with `ContentView`
- Future: Will initialize SwiftData ModelContainer

### 2. Navigation (ContentView.swift)
- Root view containing `TabView` for main navigation
- Three tabs: Dashboard, Record (Tracking), Activities
- Uses SF Symbols for tab icons

### 3. Features

#### Dashboard Feature
- **Purpose**: Display activity statistics and summaries
- **Views**: `DashboardView` shows weekly stats
- **Future**: Add charts, graphs, and detailed analytics

#### Tracking Feature
- **Purpose**: Record new activities with GPS tracking
- **Views**: `TrackingView` with map, controls, and metrics
- **Integration**: Uses `LocationService` for GPS tracking
- **Future**: Add real-time metric calculations and route visualization

#### Activities Feature
- **Purpose**: Browse and manage recorded activities
- **Views**: `ActivitiesListView` displays activity history
- **Future**: Add detail view, filtering, and search

### 4. Data Layer

#### Models
- **Activity**: SwiftData model for persisting activity data
  - Fields: type, dates, distance, duration, elevation, calories
  - Relationships: Can link to route points
- **RoutePoint**: Represents GPS coordinates along a route
  - Fields: latitude, longitude, altitude, timestamp, speed

#### Persistence (SwiftData)
- Uses SwiftData (iOS 17+) for local data persistence
- Models use `@Model` macro for automatic persistence
- Future: Add repositories for data access abstraction

### 5. Services

#### LocationService
- Wraps `CLLocationManager` for location tracking
- Observable object with `@Published` properties
- Methods: start, pause, resume, stop tracking
- Handles permissions and background location updates
- Collects `RoutePoint` objects during tracking

### 6. Theme System

#### Theme.swift
- Centralized design system
- Color palette with semantic names
- Typography scale with font definitions
- Spacing and corner radius constants
- Ensures consistent UI across the app

## Data Flow

### Recording an Activity

1. User taps "Start" in `TrackingView`
2. View calls `locationService.startTracking()`
3. `LocationService` requests location updates from GPS
4. Location updates trigger `@Published` property changes
5. View automatically updates with new metrics
6. User taps "Stop"
7. Activity data is saved to SwiftData
8. View returns to idle state

### Viewing Activities

1. User navigates to Activities tab
2. `ActivitiesListView` appears
3. View queries SwiftData for activities
4. Activities displayed in list with summary info
5. User can tap for details (to be implemented)

## Design Principles

### 1. Separation of Concerns
- Views only handle UI presentation
- Services handle business logic
- Models represent data structure

### 2. Reactive Programming
- Use `@Published` for reactive state
- Views automatically update on data changes
- Leverage Combine for complex data streams

### 3. Single Responsibility
- Each view has one clear purpose
- Services are focused on specific domains
- Models represent single entities

### 4. Dependency Injection
- Services injected into views via `@StateObject`
- Easy to test and mock
- Flexible and maintainable

### 5. Feature-Based Organization
- Code organized by feature, not layer
- Related code lives together
- Easy to navigate and maintain

## Future Enhancements

### ViewModels
As the app grows, introduce ViewModels to:
- Handle complex business logic
- Coordinate between multiple services
- Manage view state independently
- Improve testability

### Repositories
Add repository pattern to:
- Abstract data access
- Provide clean API for data operations
- Enable easier testing with mock repositories
- Support multiple data sources

### Dependency Injection
Consider using a DI container to:
- Manage service lifecycle
- Simplify testing
- Improve modularity

### Testing
- Unit tests for ViewModels and Services
- SwiftUI preview tests
- Integration tests for data flow
- UI tests for critical user journeys

## Technologies

- **SwiftUI**: Declarative UI framework
- **SwiftData**: Persistence framework (iOS 17+)
- **MapKit**: Maps and location visualization
- **CoreLocation**: GPS and location services
- **Combine**: Reactive programming

## Performance Considerations

### Location Tracking
- Use appropriate accuracy for activity type
- Implement distance filtering to reduce updates
- Consider battery impact of background tracking
- Pause updates when app is backgrounded if not needed

### Data Persistence
- Batch save operations when possible
- Use background contexts for heavy operations
- Implement pagination for large data sets
- Consider data cleanup strategies

### UI Performance
- Use lazy loading for lists
- Optimize map rendering with appropriate detail levels
- Cache computed properties when expensive
- Profile with Instruments regularly

## Security & Privacy

### Location Privacy
- Request minimum necessary permissions
- Explain location usage clearly to users
- Only track when user explicitly starts activity
- Provide option to disable background tracking

### Data Privacy
- Store all data locally by default
- Encrypt sensitive data if stored remotely
- Allow users to export/delete their data
- Follow Apple's privacy guidelines

## Conclusion

Trek's architecture is designed to be:
- **Scalable**: Easy to add new features
- **Maintainable**: Clear organization and separation
- **Testable**: Isolated components and dependencies
- **Performant**: Efficient data handling and UI updates

As the app evolves, this architecture provides a solid foundation for growth while maintaining code quality and developer productivity.
