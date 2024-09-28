//
//  WeatherService.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/25/24.
//

import Foundation
import Combine
import Core

protocol WeatherServiceProtocol {
    func getWeatherForecastInfo(lat: Double, lon: Double) -> AnyPublisher<WeatherForecastResponse, Error>
}

/// 날씨 정보 조회 서비스
struct WeatherService: WeatherServiceProtocol {
    
    @Inject private var router: NetworkRouterProtocol
    
    func getWeatherForecastInfo(lat: Double, lon: Double) -> AnyPublisher<WeatherForecastResponse, Error> {
        return router.request(
            with: WeatherEndpoint.fetchWeatherForecastInfo(lat: lat, lon: lon),
            type: WeatherForecastResponse.self
        )
        .eraseToAnyPublisher()
    }
}
