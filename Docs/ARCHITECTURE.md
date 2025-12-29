# Trek Architecture Documentation

## Overview

Trek follows the **MVVM (Model-View-ViewModel)** architecture pattern, which provides clear separation of concerns and makes the codebase maintainable and testable. The app is built using SwiftUI and modern iOS development practices.

## Architecture Pattern: MVVM

### Model
- **Purpose**: Represents the data and business logic
- **Location**: `Data/Models/`
- **Characteristics**: 
  - Pure Swift objects or SwiftData models
  - Independent of UI framework
  - Contains data validation and business rules
  - Can be easily tested

**Examples in Trek:**
- `Activity.swift`: Core activity data model with metrics and calculations
- `RoutePoint.swift`: GPS coordinate point with location metadata

### View
- **Purpose**: Displays the UI and captures user interactions
- **Location**: `Features/*/Views/`
- **Characteristics**:
  - SwiftUI views
  - Declarative UI definitions
  - Observes ViewModels for state changes
  - Minimal logic (only UI-related)

**Examples in Trek:**
- `DashboardView.swift`: Displays activity statistics
- `TrackingView.swift`: Real-time activity tracking interface
- `ActivitiesListView.swift`: Lists historical activities

### ViewModel
- **Purpose**: Mediates between Model and View
- **Location**: `Features/*/ViewModels/` (to be added)
- **Characteristics**:
  - Transforms model data for view consumption
  - Handles user actions and updates models
  - Publishes state changes using `@Published`
  - Contains presentation logic

**Future additions:**
- `DashboardViewModel.swift`
- `TrackingViewModel.swift`
- `ActivitiesViewModel.swift`

## Project Structure

```
trek/
├── TrekApp.swift                    # App entry point (@main)
├── ContentView.swift                # Root view with TabView navigation
│
├── Core/                            # Shared utilities and configurations
│   ├── Constants.swift              # App-wide constants
│   └── Theme/
│       └── Theme.swift              # Centralized theming (colors, fonts, spacing)
│
├── Features/                        # Feature-based organization (vertical slices)
│   ├── Dashboard/                   # Dashboard feature module
│   │   ├── Views/
│   │   │   └── DashboardView.swift
│   │   └── ViewModels/             # To be added
│   │       └── DashboardViewModel.swift
│   │
│   ├── Tracking/                    # Activity tracking feature module
│   │   ├── Views/
│   │   │   └── TrackingView.swift
│   │   └── ViewModels/             # To be added
│   │       └── TrackingViewModel.swift
│   │
│   └── Activities/                  # Activities history feature module
│       ├── Views/
│       │   └── ActivitiesListView.swift
│       └── ViewModels/             # To be added
│           └── ActivitiesViewModel.swift
│
├── Data/                            # Data layer
│   ├── Models/                      # Data models
│   │   ├── Activity.swift
│   │   └── RoutePoint.swift
│   └── Repositories/               # To be added
│       └── ActivityRepository.swift
│
├── Services/                        # Business logic services
│   ├── LocationService.swift       # GPS tracking service
│   └── ...                         # Future: HealthKitService, SyncService, etc.
│
├── Resources/                       # Resources and configuration
│   └── Info.plist                  # Permission keys and app configuration
│
└── Docs/                           # Documentation
    └── ARCHITECTURE.md             # This file
```

## Design Principles

### 1. Separation of Concerns
Each component has a single, well-defined responsibility:
- **Models**: Data and business rules
- **Views**: UI presentation
- **ViewModels**: Presentation logic and state management
- **Services**: External interactions (GPS, networking, persistence)

### 2. Dependency Injection
Services and dependencies are injected into ViewModels rather than being created directly:
```swift
class TrackingViewModel: ObservableObject {
    private let locationService: LocationService
    
    init(locationService: LocationService = LocationService()) {
        self.locationService = locationService
    }
}
```

### 3. Reactive Programming
Use Combine and SwiftUI's reactive features for state management:
- `@Published` for ViewModel state
- `@ObservedObject` / `@StateObject` in Views
- Combine publishers for async operations

### 4. Feature-Based Organization
Code is organized by feature rather than by type:
- Each feature module contains its own Views, ViewModels, and related code
- Makes it easy to understand and modify related functionality
- Supports team collaboration (different developers can work on different features)

## Data Flow

### Typical Data Flow Pattern

```
User Interaction
      ↓
View captures event
      ↓
View calls ViewModel method
      ↓
ViewModel updates state / calls Service
      ↓
Service performs operation (API, database, GPS, etc.)
      ↓
Service returns result
      ↓
ViewModel transforms data
      ↓
ViewModel publishes updated state
      ↓
View observes state change
      ↓
SwiftUI re-renders View
```

### Example: Starting Activity Tracking

1. User taps "Start" button in `TrackingView`
2. View calls `viewModel.startTracking()`
3. ViewModel calls `locationService.startTracking()`
4. LocationService begins collecting GPS points
5. LocationService publishes new locations
6. ViewModel observes location updates
7. ViewModel transforms locations into route data
8. ViewModel publishes updated route state
9. TrackingView observes state change
10. SwiftUI updates map and statistics displays

## State Management

### View State
Local UI state (e.g., selected tab, expanded section) stays in the View using `@State`:
```swift
@State private var selectedActivityType: ActivityType = .running
```

### Shared State
State shared across views or persisted goes in ViewModels using `@Published`:
```swift
@Published var activities: [Activity] = []
```

### Global State
App-wide state can use:
- **Environment Objects**: Injected at app root
- **Singletons**: For services (use sparingly)
- **SwiftData**: For persistent data

## Services Layer

Services encapsulate external interactions and complex business logic:

### LocationService
- Manages CLLocationManager
- Handles permissions
- Provides route tracking functionality
- Publishes location updates

### Future Services
- **ActivityRepository**: CRUD operations for activities
- **HealthKitService**: Integration with Apple Health
- **SyncService**: Cloud sync and backup
- **AuthService**: User authentication
- **AnalyticsService**: Usage analytics and insights

## Testing Strategy

### Unit Tests
- Test ViewModels in isolation
- Test Models' business logic
- Test Service methods
- Mock dependencies using protocols

### Integration Tests
- Test ViewModel + Service interactions
- Test data persistence
- Test location tracking flow

### UI Tests
- Test critical user flows
- Test navigation
- Test accessibility

## SwiftData Integration

Trek uses SwiftData for persistence:

### Model Definition
```swift
@Model
final class Activity {
    var id: UUID
    var type: String
    // ... other properties
}
```

### Model Container
Set up in TrekApp.swift:
```swift
@main
struct TrekApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Activity.self, RoutePoint.self])
    }
}
```

### Querying Data
Use `@Query` in Views or ViewModels:
```swift
@Query(sort: \Activity.startDate, order: .reverse) 
var activities: [Activity]
```

## Future Enhancements

### Planned Architecture Improvements

1. **Add ViewModels**
   - Create ViewModel for each major view
   - Move business logic from Views to ViewModels
   - Improve testability

2. **Repository Pattern**
   - Abstract data access behind repository interfaces
   - Makes it easy to switch data sources
   - Simplifies testing with mock repositories

3. **Coordinator Pattern**
   - Manage navigation flow
   - Reduce coupling between views
   - Support deep linking

4. **Dependency Injection Container**
   - Centralized dependency management
   - Better control over object lifetimes
   - Easier testing with mock dependencies

5. **Feature Flags**
   - Enable/disable features remotely
   - A/B testing support
   - Gradual rollouts

## Best Practices

### SwiftUI Views
- Keep views small and focused
- Extract reusable components
- Use view modifiers for consistent styling
- Prefer composition over inheritance

### ViewModels
- One ViewModel per screen/feature
- No UIKit dependencies
- All properties `@Published` that affect UI
- Use async/await for async operations

### Models
- Immutable when possible
- Validate data in initializers
- Provide convenient computed properties
- Include sample data for previews

### Services
- Define protocol interfaces
- Make testable with dependency injection
- Handle errors gracefully
- Use async/await for async operations

### Code Organization
- One type per file
- Group related files in folders
- Use extensions to organize code
- Follow Swift API Design Guidelines

## Resources

### Apple Documentation
- [SwiftUI](https://developer.apple.com/documentation/swiftui)
- [SwiftData](https://developer.apple.com/documentation/swiftdata)
- [Combine](https://developer.apple.com/documentation/combine)
- [CoreLocation](https://developer.apple.com/documentation/corelocation)

### Design Patterns
- [MVVM Pattern](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93viewmodel)
- [Coordinator Pattern](https://khanlou.com/2015/10/coordinators-redux/)
- [Repository Pattern](https://martinfowler.com/eaaCatalog/repository.html)

### Swift Guidelines
- [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- [Swift Style Guide](https://google.github.io/swift/)

---

**Document Version**: 1.0  
**Last Updated**: 2024  
**Maintained By**: Trek Development Team
