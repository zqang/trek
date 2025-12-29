//
//  RouteMapView.swift
//  Trek
//
//  Created on December 29, 2025.
//

import SwiftUI
import MapKit

struct RouteMapView: View {
    let route: [LocationPoint]
    @State private var region: MKCoordinateRegion
    @State private var polyline: MKPolyline?

    init(route: [LocationPoint]) {
        self.route = route

        // Calculate initial region from route
        let coordinates = route.map { $0.coordinate }
        let region = Self.calculateRegion(from: coordinates)
        _region = State(initialValue: region)
    }

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: annotations) { annotation in
            if annotation.type == .start {
                MapAnnotation(coordinate: annotation.coordinate) {
                    Image(systemName: "flag.fill")
                        .foregroundColor(.green)
                        .font(.title2)
                }
            } else if annotation.type == .end {
                MapAnnotation(coordinate: annotation.coordinate) {
                    Image(systemName: "flag.checkered")
                        .foregroundColor(.red)
                        .font(.title2)
                }
            }
        }
        .overlay(
            RoutePolylineView(route: route)
        )
    }

    private var annotations: [RouteAnnotation] {
        var items: [RouteAnnotation] = []

        if let first = route.first {
            items.append(RouteAnnotation(
                id: "start",
                coordinate: first.coordinate,
                type: .start
            ))
        }

        if let last = route.last, route.count > 1 {
            items.append(RouteAnnotation(
                id: "end",
                coordinate: last.coordinate,
                type: .end
            ))
        }

        return items
    }

    // Calculate region that fits all coordinates
    private static func calculateRegion(from coordinates: [CLLocationCoordinate2D]) -> MKCoordinateRegion {
        guard !coordinates.isEmpty else {
            return MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 37.33182, longitude: -122.03118),
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        }

        let latitudes = coordinates.map { $0.latitude }
        let longitudes = coordinates.map { $0.longitude }

        let maxLat = latitudes.max() ?? 0
        let minLat = latitudes.min() ?? 0
        let maxLon = longitudes.max() ?? 0
        let minLon = longitudes.min() ?? 0

        let center = CLLocationCoordinate2D(
            latitude: (maxLat + minLat) / 2,
            longitude: (maxLon + minLon) / 2
        )

        let span = MKCoordinateSpan(
            latitudeDelta: (maxLat - minLat) * 1.5, // Add 50% padding
            longitudeDelta: (maxLon - minLon) * 1.5
        )

        return MKCoordinateRegion(center: center, span: span)
    }
}

// MARK: - Route Polyline View
struct RoutePolylineView: UIViewRepresentable {
    let route: [LocationPoint]

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.isUserInteractionEnabled = false
        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        // Remove existing overlays
        mapView.removeOverlays(mapView.overlays)

        // Add route polyline
        if route.count >= 2 {
            let coordinates = route.map { $0.coordinate }
            let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
            mapView.addOverlay(polyline)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .systemBlue
                renderer.lineWidth = 4
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}

// MARK: - Route Annotation
struct RouteAnnotation: Identifiable {
    let id: String
    let coordinate: CLLocationCoordinate2D
    let type: AnnotationType

    enum AnnotationType {
        case start
        case end
    }
}

#Preview {
    RouteMapView(route: [
        LocationPoint(latitude: 37.33182, longitude: -122.03118, altitude: 20, timestamp: Date(), speed: 0, horizontalAccuracy: 10),
        LocationPoint(latitude: 37.33282, longitude: -122.03218, altitude: 22, timestamp: Date(), speed: 2, horizontalAccuracy: 10),
        LocationPoint(latitude: 37.33382, longitude: -122.03318, altitude: 24, timestamp: Date(), speed: 2.5, horizontalAccuracy: 10)
    ])
}
