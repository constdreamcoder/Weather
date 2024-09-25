//
//  SearchIntent.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/25/24.
//

import SwiftUI
import Combine

protocol IntentType: ObservableObject {
    associatedtype Action
        
    func send(_ action: Action)
}

final class SearchIntent: IntentType {
    
    private var weatherService: WeatherServiceProtocol
    
    init(weatherService: WeatherServiceProtocol) {
        self.weatherService = weatherService
    }
    
    var cancelable = Set<AnyCancellable>()
    
    enum Action {
        case getWeatherForecaseInfo
    }
    
    func send(_ action: Action) {
        switch action {
        case .getWeatherForecaseInfo:
            getWeatherForecaseInfo(lat: 37.55272, lon: 126.98101)
        }
    }
}

extension SearchIntent {
    private func getWeatherForecaseInfo(lat: Double, lon: Double) {
        weatherService.getWeatherForecastInfo(lat: lat, lon: lon)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("error",error)
                }
            } receiveValue: { weatherResponse in
                print(weatherResponse)
              
            }
            .store(in: &cancelable)

    }
}
