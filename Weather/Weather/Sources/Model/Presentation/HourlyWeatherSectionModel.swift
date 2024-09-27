//
//  HourlyWeatherSectionModel.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/27/24.
//

import Foundation

struct HourlyWeatherSectionModel {
    var windGust: Int = 0
    var hourlyWeatherDatas: [HourlyWeatherData] = []
    
    init(from result: WeatherForecastResponse?) {
        guard let result else { return }
        
        self.windGust = Int(result.current.windGust ?? 0)
        
        self.hourlyWeatherDatas = result.hourly.enumerated().compactMap { index, element in
            if index % 3 == 0 {
                let hour = DateFormatterManager.shared.unixTimeToFormattedTime(
                    element.dt,
                    timeZoneId: result.timezone
                )
                return HourlyWeatherData(
                    dt: element.dt,
                    temp: Int(element.temp),
                    weather: element.weather,
                    hour: hour
                )
            }
            return nil
        }
        
        self.hourlyWeatherDatas[0].hour = "지금"
    }
}

struct HourlyWeatherData {
    var dt: Int = 0
    var temp: Int = 0
    var weather: [WeatherDescription] = []
    var hour: String = ""
}
