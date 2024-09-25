//
//  SearchCore.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/25/24.
//

import Foundation
import Combine
import CoreLocation

final class SearchReducer: ReducerProtocol {
    struct State {
        var isPresented: Bool = false
        var text: String = ""
        var coordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(
            latitude: 37.55272,
            longitude: 126.98101
        )
        var currentWeather = CurrentWeather()
        
        var searchText: String = ""
        var filteredCityList: [City] = City.loadCityList()
        
        struct CurrentWeather {
            var name: String = "Seoul"
            var temp: Int = 0
            var description: String = "맑음"
            var min: Int = 0
            var max: Int = 0
        }
    }
    
    enum Action {
        case present(isPresented: Bool)
        case write(searchText: String)
        case selectCity(city: City)
        case fetchComplete(result: WeatherForecastResponse)
        case fetchError
    }
    
    private let weatherService: WeatherServiceProtocol
    
    init(weatherService: WeatherServiceProtocol) {
        self.weatherService = weatherService
    }
    
    func reduce(state: inout State, action: Action) -> Effect {
        switch action {
        case .present(let isPresented):
            state.isPresented = isPresented
            return .none
        case .write(let searchText):
            state.searchText = searchText
            state.filteredCityList = City.loadCityList().filter {
                $0.name.hasPrefix(searchText) || searchText == ""
            }
            return .none
        case .selectCity(let city):
            state.currentWeather.name = city.name
            return .publisher(
                weatherService.getWeatherForecastInfo(
                    lat: city.coord.lat,
                    lon:  city.coord.lon
                )
                .map { weatherForecastResponse in
                    print("weatherForecastResponse")
                    print(weatherForecastResponse)
                    return Action.fetchComplete(result: weatherForecastResponse)
                }
                    .catch { error in
                        Just(Action.fetchError)
                    }
                    .eraseToAnyPublisher()
            )
        case .fetchComplete(let result):
            print("완료")
            state.currentWeather.description = result.current.weather[0].description
            state.currentWeather.temp = Int(result.current.temp)
            state.currentWeather.min = Int(result.daily[0].temp.min)
            state.currentWeather.max = Int(result.daily[0].temp.max)
            
            state.coordinates.latitude = result.lat
            state.coordinates.longitude = result.lon
            
            state.isPresented = false
            return .none
        case .fetchError:
            print("조회 에러")
            state.currentWeather.name = "Seoul"
            return .none
        }
    }
}
