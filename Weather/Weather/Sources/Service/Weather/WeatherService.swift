//
//  WeatherService.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/25/24.
//

import Foundation
import Combine

protocol WeatherServiceProtocol {
    func getWeatherForecastInfo(lat: Double, lon: Double) -> AnyPublisher<WeatherForecastResponse, Error>
}

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
