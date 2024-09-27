//
//  MeteorologicalFactorUpperSectionModel.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/27/24.
//

import Foundation

struct MeteorologicalFactorUpperSectionModel  {
    var meteorologicalFactorsUpperDatas: [MeteorologicalFactorData] = []
    
    init(from result: WeatherForecastResponse?) {
        guard let result else { return }
        
        let humidity = MeteorologicalFactorData(
            name: "습도",
            value: result.current.humidity
        )
        
        let clouds = MeteorologicalFactorData(
            name: "구름",
            value: result.current.clouds
        )
        
        self.meteorologicalFactorsUpperDatas = [humidity, clouds]
    }
}

struct MeteorologicalFactorData: Identifiable {
    let id = UUID()
    var name: String = ""
    var value: Int = 0
}
