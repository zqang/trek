//
//  ActivitiesListView.swift
//  Trek
//
//  Created on December 29, 2025.
//

import SwiftUI

struct ActivitiesListView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel: ActivitiesViewModel
    @State private var selectedActivity: Activity?
    @State private var showingFilters = false
    @State private var showingSortMenu = false
    @State private var activityToDelete: Activity?
    @State private var showingDeleteConfirmation = false
    @State private var selectedTab = 0

    init(userId: String) {
        _viewModel = StateObject(wrappedValue: ActivitiesViewModel(userId: userId))
    }

    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading && viewModel.activities.isEmpty {
                    // Initial loading
                    ProgressView("Loading activities...")
                } else if viewModel.activities.isEmpty {
                    // Empty state
                    EmptyActivitiesView(
                        hasFilters: hasActiveFilters,
                        onStartRecording: {
                            // Switch to recording tab
                            selectedTab = 1
                        },
                        onClearFilters: {
                            viewModel.clearFilters()
                        }
                    )
                } else {
                    // Activities list
                    activitiesList
                }
            }
            .navigationTitle("Activities")
            .searchable(text: $viewModel.searchText, prompt: "Search activities")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    filterButton
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    sortButton
                }
            }
            .sheet(item: $selectedActivity) { activity in
                ActivityDetailView(activity: activity)
                    .environmentObject(authViewModel)
            }
            .alert("Delete Activity?", isPresented: $showingDeleteConfirmation, presenting: activityToDelete) { activity in
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    Task {
                        await viewModel.deleteActivity(activity)
                    }
                }
            } message: { activity in
                Text("Are you sure you want to delete \"\(activity.name)\"? This action cannot be undone.")
            }
            .alert("Error", isPresented: $viewModel.showingError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "An unknown error occurred")
            }
            .refreshable {
                await viewModel.refreshActivities()
            }
            .task {
                if viewModel.activities.isEmpty {
                    await viewModel.fetchActivities()
                }
            }
        }
    }

    // MARK: - Activities List
    private var activitiesList: some View {
        ScrollView {
            LazyVStack(spacing: 15) {
                // Active filters indicator
                if hasActiveFilters {
                    activeFiltersView
                }

                // Activities
                ForEach(viewModel.activities) { activity in
                    Button(action: {
                        selectedActivity = activity
                    }) {
                        ActivityRowView(activity: activity)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .contextMenu {
                        Button(action: {
                            selectedActivity = activity
                        }) {
                            Label("View Details", systemImage: "eye")
                        }

                        Button(role: .destructive, action: {
                            activityToDelete = activity
                            showingDeleteConfirmation = true
                        }) {
                            Label("Delete", systemImage: "trash")
                        }

                        Button(action: {
                            shareActivity(activity)
                        }) {
                            Label("Share GPX", systemImage: "square.and.arrow.up")
                        }
                    }

                    // Load more when reaching near bottom
                    if activity.id == viewModel.activities.last?.id {
                        loadMoreView
                    }
                }
            }
            .padding()
        }
    }

    // MARK: - Active Filters View
    private var activeFiltersView: some View {
        HStack {
            Text("Filters Active")
                .font(.subheadline)
                .foregroundColor(.secondary)

            if let type = viewModel.selectedActivityType {
                FilterChip(text: type.displayName, icon: type.icon) {
                    viewModel.setActivityTypeFilter(nil)
                }
            }

            Spacer()

            Button("Clear All") {
                viewModel.clearFilters()
            }
            .font(.subheadline)
            .foregroundColor(.accentColor)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .padding(.horizontal)
    }

    // MARK: - Load More View
    private var loadMoreView: some View {
        Group {
            if viewModel.isLoadingMore {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .padding()
            } else if viewModel.hasMoreActivities {
                Color.clear
                    .frame(height: 1)
                    .onAppear {
                        Task {
                            await viewModel.loadMoreActivities()
                        }
                    }
            }
        }
    }

    // MARK: - Filter Button
    private var filterButton: some View {
        Menu {
            Button(action: {
                viewModel.setActivityTypeFilter(nil)
            }) {
                Label("All Activities", systemImage: viewModel.selectedActivityType == nil ? "checkmark" : "")
            }

            Divider()

            ForEach(ActivityType.allCases, id: \.self) { type in
                Button(action: {
                    viewModel.setActivityTypeFilter(type)
                }) {
                    Label(
                        type.displayName,
                        systemImage: viewModel.selectedActivityType == type ? "checkmark" : type.icon
                    )
                }
            }
        } label: {
            Image(systemName: hasActiveFilters ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
        }
    }

    // MARK: - Sort Button
    private var sortButton: some View {
        Menu {
            ForEach(SortOrder.allCases) { order in
                Button(action: {
                    viewModel.setSortOrder(order)
                }) {
                    Label(
                        order.rawValue,
                        systemImage: viewModel.sortOrder == order ? "checkmark" : order.icon
                    )
                }
            }
        } label: {
            Image(systemName: "arrow.up.arrow.down.circle")
        }
    }

    // MARK: - Helper Properties
    private var hasActiveFilters: Bool {
        viewModel.selectedActivityType != nil || !viewModel.searchText.isEmpty
    }

    // MARK: - Share Activity
    private func shareActivity(_ activity: Activity) {
        let gpxString = viewModel.exportActivityAsGPX(activity)

        // Create temporary file
        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("\(activity.name).gpx")

        do {
            try gpxString.write(to: tempURL, atomically: true, encoding: .utf8)

            let activityVC = UIActivityViewController(
                activityItems: [tempURL],
                applicationActivities: nil
            )

            // Present activity controller
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootViewController = windowScene.windows.first?.rootViewController {
                rootViewController.present(activityVC, animated: true)
            }
        } catch {
            print("Error sharing activity: \(error)")
        }
    }
}

// MARK: - Filter Chip
struct FilterChip: View {
    let text: String
    let icon: String
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption)

            Text(text)
                .font(.caption)

            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .font(.caption)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.accentColor.opacity(0.2))
        .foregroundColor(.accentColor)
        .cornerRadius(16)
    }
}

#Preview {
    ActivitiesListView(userId: "user123")
        .environmentObject(AuthViewModel())
}
