//
//  MapView.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/24/24.
//

import SwiftUI
import UIKit
import MapKit

/// 맵 뷰
struct MapView: UIViewRepresentable {
    
    @Binding var coordinates: CLLocationCoordinate2D?
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView()
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if let coordinates {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            uiView.addAnnotation(annotation)
            
            let region = MKCoordinateRegion(
                center: coordinates,
                latitudinalMeters: 2000,
                longitudinalMeters: 2000
            )
            uiView.setRegion(region, animated: true)
        }
    }
}
