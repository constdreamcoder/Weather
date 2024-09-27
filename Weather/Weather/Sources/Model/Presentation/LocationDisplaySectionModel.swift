//
//  LocationDisplaySectionModel.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/27/24.
//

import Foundation
import CoreLocation

struct LocationDisplaySectionModel {
    var coordinate = CLLocationCoordinate2D()
    
    init(from result: WeatherForecastResponse?) {
        guard let result else { return }
        
        self.coordinate.latitude = result.lat
        self.coordinate.longitude = result.lon
    }
}
