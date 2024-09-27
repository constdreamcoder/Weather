//
//  HourlyWeatherSectionModel.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/27/24.
//

import Foundation

struct HourlyWeatherSectionModel {
    var dt: Int = 0
    var temp: Int = 0
    var weather: [WeatherDescription] = []
    var hour: String = ""
}
