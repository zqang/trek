//
//  NetworkMonitor.swift
//  Trek
//
//  Created on December 29, 2025.
//

import Foundation
import Network
import Combine

@MainActor
class NetworkMonitor: ObservableObject {
    static let shared = NetworkMonitor()

    @Published var isConnected: Bool = true
    @Published var connectionType: ConnectionType = .wifi

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")

    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknown
        case none

        var displayName: String {
            switch self {
            case .wifi: return "Wi-Fi"
            case .cellular: return "Cellular"
            case .ethernet: return "Ethernet"
            case .unknown: return "Unknown"
            case .none: return "No Connection"
            }
        }

        var icon: String {
            switch self {
            case .wifi: return "wifi"
            case .cellular: return "antenna.radiowaves.left.and.right"
            case .ethernet: return "cable.connector"
            case .unknown: return "network"
            case .none: return "wifi.slash"
            }
        }
    }

    private init() {
        startMonitoring()
    }

    // MARK: - Start Monitoring

    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            Task { @MainActor [weak self] in
                guard let self = self else { return }

                self.isConnected = path.status == .satisfied

                // Determine connection type
                if path.usesInterfaceType(.wifi) {
                    self.connectionType = .wifi
                } else if path.usesInterfaceType(.cellular) {
                    self.connectionType = .cellular
                } else if path.usesInterfaceType(.wiredEthernet) {
                    self.connectionType = .ethernet
                } else if path.status == .satisfied {
                    self.connectionType = .unknown
                } else {
                    self.connectionType = .none
                }

                // Post notification for other parts of the app
                if self.isConnected {
                    NotificationCenter.default.post(name: .networkConnected, object: nil)
                } else {
                    NotificationCenter.default.post(name: .networkDisconnected, object: nil)
                }
            }
        }

        monitor.start(queue: queue)
    }

    // MARK: - Stop Monitoring

    func stopMonitoring() {
        monitor.cancel()
    }

    // MARK: - Helper Properties

    var isOnWiFi: Bool {
        isConnected && connectionType == .wifi
    }

    var isOnCellular: Bool {
        isConnected && connectionType == .cellular
    }

    var statusMessage: String {
        if isConnected {
            return "Connected via \(connectionType.displayName)"
        } else {
            return "No internet connection"
        }
    }
}

// MARK: - Notification Names

extension Notification.Name {
    static let networkConnected = Notification.Name("networkConnected")
    static let networkDisconnected = Notification.Name("networkDisconnected")
}
