//
//  SkeletonView.swift
//  Trek
//
//  Created on December 29, 2025.
//

import SwiftUI

// MARK: - Skeleton View
struct SkeletonView: View {
    @State private var phase: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .overlay(
                    LinearGradient(
                        colors: [
                            Color.clear,
                            Color.white.opacity(0.4),
                            Color.clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geometry.size.width * 0.3)
                    .offset(x: phase * geometry.size.width)
                )
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .onAppear {
                    withAnimation(
                        Animation.linear(duration: 1.5)
                            .repeatForever(autoreverses: false)
                    ) {
                        phase = 1.3
                    }
                }
        }
    }
}

// MARK: - Activity Row Skeleton
struct ActivityRowSkeleton: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                SkeletonView()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 4) {
                    SkeletonView()
                        .frame(height: 16)
                        .frame(maxWidth: 150)

                    SkeletonView()
                        .frame(height: 12)
                        .frame(maxWidth: 100)
                }

                Spacer()
            }

            // Stats
            HStack(spacing: 20) {
                ForEach(0..<4) { _ in
                    VStack(spacing: 4) {
                        SkeletonView()
                            .frame(height: 12)
                        SkeletonView()
                            .frame(height: 16)
                        SkeletonView()
                            .frame(height: 10)
                    }
                    .frame(maxWidth: .infinity)
                }
            }

            // Map
            SkeletonView()
                .frame(height: 120)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - Profile Skeleton
struct ProfileSkeleton: View {
    var body: some View {
        VStack(spacing: 20) {
            // Profile Photo
            SkeletonView()
                .frame(width: 100, height: 100)
                .clipShape(Circle())

            // Name
            SkeletonView()
                .frame(height: 24)
                .frame(maxWidth: 200)

            // Email
            SkeletonView()
                .frame(height: 16)
                .frame(maxWidth: 150)

            // Stats Grid
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 15) {
                ForEach(0..<4) { _ in
                    VStack(spacing: 8) {
                        SkeletonView()
                            .frame(height: 20)
                        SkeletonView()
                            .frame(height: 16)
                        SkeletonView()
                            .frame(height: 12)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
            }
        }
        .padding()
    }
}

// MARK: - List Skeleton
struct ListSkeleton: View {
    let count: Int

    init(count: Int = 5) {
        self.count = count
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                ForEach(0..<count, id: \.self) { index in
                    ActivityRowSkeleton()
                        .transition(.opacity)
                }
            }
            .padding()
        }
    }
}

// MARK: - Card Skeleton
struct CardSkeleton: View {
    let height: CGFloat

    init(height: CGFloat = 200) {
        self.height = height
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SkeletonView()
                .frame(height: 20)
                .frame(maxWidth: 150)

            SkeletonView()
                .frame(height: height)

            HStack {
                SkeletonView()
                    .frame(height: 16)
                    .frame(maxWidth: 100)

                Spacer()

                SkeletonView()
                    .frame(width: 60, height: 16)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - Text Skeleton
struct TextSkeleton: View {
    let lines: Int
    let spacing: CGFloat

    init(lines: Int = 3, spacing: CGFloat = 8) {
        self.lines = lines
        self.spacing = spacing
    }

    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            ForEach(0..<lines, id: \.self) { index in
                SkeletonView()
                    .frame(height: 16)
                    .frame(maxWidth: index == lines - 1 ? 200 : .infinity)
            }
        }
    }
}

// MARK: - View Extension
extension View {
    @ViewBuilder
    func skeleton(isLoading: Bool) -> some View {
        if isLoading {
            self
                .redacted(reason: .placeholder)
                .shimmer()
        } else {
            self
        }
    }
}

#Preview("Activity Row Skeleton") {
    ActivityRowSkeleton()
        .padding()
}

#Preview("Profile Skeleton") {
    ProfileSkeleton()
}

#Preview("List Skeleton") {
    ListSkeleton(count: 3)
}

#Preview("Card Skeleton") {
    CardSkeleton()
        .padding()
}
