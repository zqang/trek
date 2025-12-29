//
//  GPSSignalIndicator.swift
//  Trek
//
//  Created on December 29, 2025.
//

import SwiftUI
import CoreLocation

struct GPSSignalIndicator: View {
    let accuracy: Double?
    let isTracking: Bool

    var signalQuality: SignalQuality {
        guard let accuracy = accuracy else {
            return .none
        }

        if accuracy <= 10 {
            return .excellent
        } else if accuracy <= 20 {
            return .good
        } else if accuracy <= 50 {
            return .fair
        } else {
            return .poor
        }
    }

    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: signalIcon)
                .font(.caption)
                .foregroundColor(signalColor)

            if isTracking {
                Text(signalText)
                    .font(.caption2)
                    .foregroundColor(signalColor)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(signalColor.opacity(0.1))
        .cornerRadius(8)
    }

    private var signalIcon: String {
        switch signalQuality {
        case .excellent:
            return "antenna.radiowaves.left.and.right"
        case .good:
            return "antenna.radiowaves.left.and.right"
        case .fair:
            return "antenna.radiowaves.left.and.right"
        case .poor:
            return "antenna.radiowaves.left.and.right.slash"
        case .none:
            return "location.slash"
        }
    }

    private var signalColor: Color {
        switch signalQuality {
        case .excellent:
            return .green
        case .good:
            return .green
        case .fair:
            return .orange
        case .poor:
            return .red
        case .none:
            return .gray
        }
    }

    private var signalText: String {
        guard let accuracy = accuracy else {
            return "No Signal"
        }

        switch signalQuality {
        case .excellent:
            return "Excellent"
        case .good:
            return "Good"
        case .fair:
            return "Fair (\(Int(accuracy))m)"
        case .poor:
            return "Poor (\(Int(accuracy))m)"
        case .none:
            return "No Signal"
        }
    }
}

enum SignalQuality {
    case excellent  // ≤10m
    case good       // ≤20m
    case fair       // ≤50m
    case poor       // >50m
    case none       // No location
}

#Preview {
    VStack(spacing: 20) {
        GPSSignalIndicator(accuracy: 5, isTracking: true)
        GPSSignalIndicator(accuracy: 15, isTracking: true)
        GPSSignalIndicator(accuracy: 35, isTracking: true)
        GPSSignalIndicator(accuracy: 75, isTracking: true)
        GPSSignalIndicator(accuracy: nil, isTracking: false)
    }
    .padding()
}
