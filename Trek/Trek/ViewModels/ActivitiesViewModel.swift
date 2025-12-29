//
//  ActivitiesViewModel.swift
//  Trek
//
//  Created on December 29, 2025.
//

import Foundation
import Combine
import FirebaseFirestore

@MainActor
class ActivitiesViewModel: ObservableObject {
    @Published var activities: [Activity] = []
    @Published var isLoading = false
    @Published var isLoadingMore = false
    @Published var hasMoreActivities = true
    @Published var errorMessage: String?
    @Published var showingError = false

    // Filtering and sorting
    @Published var selectedActivityType: ActivityType?
    @Published var sortOrder: SortOrder = .dateDescending
    @Published var searchText = ""

    private let activityService = ActivityService()
    private var lastDocument: DocumentSnapshot?
    private let pageSize = 20
    private var cancellables = Set<AnyCancellable>()

    let userId: String

    init(userId: String) {
        self.userId = userId
        setupSearchDebounce()
    }

    // MARK: - Setup

    private func setupSearchDebounce() {
        // Debounce search to avoid too many queries
        $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                Task {
                    await self?.refreshActivities()
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Fetch Activities

    func fetchActivities() async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        do {
            let (fetchedActivities, lastDoc) = try await activityService.fetchActivities(
                userId: userId,
                limit: pageSize,
                lastDocument: nil
            )

            activities = applyFiltersAndSorting(to: fetchedActivities)
            lastDocument = lastDoc
            hasMoreActivities = fetchedActivities.count == pageSize
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            showingError = true
            isLoading = false
        }
    }

    // MARK: - Load More

    func loadMoreActivities() async {
        guard !isLoadingMore && hasMoreActivities else { return }

        isLoadingMore = true

        do {
            let (fetchedActivities, lastDoc) = try await activityService.fetchActivities(
                userId: userId,
                limit: pageSize,
                lastDocument: lastDocument
            )

            let filteredActivities = applyFiltersAndSorting(to: fetchedActivities)
            activities.append(contentsOf: filteredActivities)
            lastDocument = lastDoc
            hasMoreActivities = fetchedActivities.count == pageSize
            isLoadingMore = false
        } catch {
            errorMessage = error.localizedDescription
            showingError = true
            isLoadingMore = false
        }
    }

    // MARK: - Refresh

    func refreshActivities() async {
        lastDocument = nil
        hasMoreActivities = true
        await fetchActivities()
    }

    // MARK: - Delete Activity

    func deleteActivity(_ activity: Activity) async {
        guard let activityId = activity.id else { return }

        do {
            try await activityService.deleteActivity(id: activityId, userId: userId)

            // Remove from local array
            activities.removeAll { $0.id == activityId }
        } catch {
            errorMessage = error.localizedDescription
            showingError = true
        }
    }

    // MARK: - Filtering and Sorting

    private func applyFiltersAndSorting(to activities: [Activity]) -> [Activity] {
        var filtered = activities

        // Filter by activity type
        if let selectedType = selectedActivityType {
            filtered = filtered.filter { $0.type == selectedType }
        }

        // Filter by search text
        if !searchText.isEmpty {
            filtered = filtered.filter { activity in
                activity.name.lowercased().contains(searchText.lowercased())
            }
        }

        // Sort
        switch sortOrder {
        case .dateDescending:
            filtered.sort { $0.createdAt > $1.createdAt }
        case .dateAscending:
            filtered.sort { $0.createdAt < $1.createdAt }
        case .distanceDescending:
            filtered.sort { $0.distance > $1.distance }
        case .distanceAscending:
            filtered.sort { $0.distance < $1.distance }
        case .durationDescending:
            filtered.sort { $0.duration > $1.duration }
        case .durationAscending:
            filtered.sort { $0.duration < $1.duration }
        }

        return filtered
    }

    // MARK: - Filter Actions

    func setActivityTypeFilter(_ type: ActivityType?) {
        selectedActivityType = type
        Task {
            await refreshActivities()
        }
    }

    func setSortOrder(_ order: SortOrder) {
        sortOrder = order
        activities = applyFiltersAndSorting(to: activities)
    }

    func clearFilters() {
        selectedActivityType = nil
        searchText = ""
        sortOrder = .dateDescending
        Task {
            await refreshActivities()
        }
    }

    // MARK: - Export Activity

    func exportActivityAsGPX(_ activity: Activity) -> String {
        return activityService.exportActivityAsGPX(activity)
    }
}

// MARK: - Sort Order

enum SortOrder: String, CaseIterable, Identifiable {
    case dateDescending = "Newest First"
    case dateAscending = "Oldest First"
    case distanceDescending = "Longest Distance"
    case distanceAscending = "Shortest Distance"
    case durationDescending = "Longest Duration"
    case durationAscending = "Shortest Duration"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .dateDescending, .dateAscending:
            return "calendar"
        case .distanceDescending, .distanceAscending:
            return "figure.run"
        case .durationDescending, .durationAscending:
            return "clock"
        }
    }
}
