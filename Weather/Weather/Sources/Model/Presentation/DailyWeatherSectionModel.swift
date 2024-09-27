//
//  DailyWeatherSectionModel.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/27/24.
//

import Foundation

struct DailyWeatherSectionModel {
    var dt: Int = 0
    var min: Int = 0
    var max: Int = 0
    var weather: [WeatherDescription] = []
    var dayOfWeek: String = ""
}
