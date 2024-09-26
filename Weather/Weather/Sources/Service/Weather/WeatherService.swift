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
    
    private let router: NetworkRouterProtocol
    
    init(router: NetworkRouterProtocol) {
        self.router = router
    }
    
    func getWeatherForecastInfo(lat: Double, lon: Double) -> AnyPublisher<WeatherForecastResponse, Error> {
        return router.request(
            with: WeatherEndpoint.fetchWeatherForecastInfo(lat: lat, lon: lon),
            type: WeatherForecastResponse.self
        )
        .eraseToAnyPublisher()
    }
}
