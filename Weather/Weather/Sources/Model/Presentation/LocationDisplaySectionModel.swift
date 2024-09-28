//
//  LocationDisplaySectionModel.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/27/24.
//

import Foundation
import CoreLocation

/// 도시 위치 표시 섹션 데이터 모델
struct LocationDisplaySectionModel {
    var coordinate = CLLocationCoordinate2D()
    
    init(from result: WeatherForecastResponse?) {
        guard let result else { return }
        
        self.coordinate.latitude = result.lat
        self.coordinate.longitude = result.lon
    }
}
