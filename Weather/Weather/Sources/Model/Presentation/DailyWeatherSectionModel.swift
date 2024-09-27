//
//  DailyWeatherSectionModel.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/27/24.
//

import Foundation

struct DailyWeatherSectionModel {
    var dailyWeatherDatas: [DailyWeatherData] = []
    
    init(from result: WeatherForecastResponse?) {
        guard let result else { return }
        
        self.dailyWeatherDatas = result.daily[0..<5].map {
            let dayOfWeek = DateFormatterManager.shared.dayOfWeek(from: $0.dt)
            return DailyWeatherData(
                dt: $0.dt,
                min: Int($0.temp.min),
                max: Int($0.temp.max),
                weather: $0.weather,
                dayOfWeek: dayOfWeek
            )
        }
        
        self.dailyWeatherDatas[0].dayOfWeek = "오늘"
    }
}

struct DailyWeatherData {
    var dt: Int = 0
    var min: Int = 0
    var max: Int = 0
    var weather: [WeatherDescription] = []
    var dayOfWeek: String = ""
}
