//
//  MeteorologicalFactorLowerSectionModel.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/27/24.
//

import Foundation

/// 기상 요소 중 바람 섹션 데이터 모델
struct MeteorologicalFactorLowerSectionModel {
    var name: String = ""
    var value: Double = 0
    var additionalValue: Double = 0
    
    init(from result: WeatherForecastResponse?) {
        guard let result else { return }
        
        self.name = "바람 속도"
        self.value = result.current.windSpeed
        self.additionalValue = result.current.windGust ?? 0
    }
}
