//
//  CurrentWeatherSectionModel.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/27/24.
//

import Foundation

/// 현재 도시 날씨 정보 섹션 데이터 모델
struct CurrentWeatherSectionModel {
    var name: String = ""
    var temp: Int = 0
    var description: String = ""
    var min: Int = 0
    var max: Int = 0
    
    init(from result: WeatherForecastResponse?, with city: City?) {
        guard let result else { return }
        
        self.name = city?.name ?? ""
        self.description = result.current.weather[0].description
        self.temp = Int(result.current.temp)
        self.min = Int(result.daily[0].temp.min)
        self.max = Int(result.daily[0].temp.max)
    }
}
