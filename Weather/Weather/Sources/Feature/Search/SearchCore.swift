//
//  SearchCore.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/25/24.
//

import Foundation
import Combine

final class SearchReducer: ReducerProtocol {
    struct State {
        var searchText: String = ""
        var filteredCityList: [City] = City.loadCityList()
    }
    
    enum Action {
        case write(searchText: String)
        case selectCity(coord: Coordinate)
        case fetchComplete
        case fetchError
    }
    
    private let weatherService: WeatherServiceProtocol
    
    init(weatherService: WeatherServiceProtocol) {
        self.weatherService = weatherService
    }
    
    func reduce(state: inout State, action: Action) -> Effect {
        switch action {
        case .write(let searchText):
            state.searchText = searchText
            state.filteredCityList = City.loadCityList().filter {
                $0.name.hasPrefix(searchText) || searchText == ""
            }
            return .none
        case .selectCity(let coord):
            return .publisher(
                weatherService.getWeatherForecastInfo(lat: coord.lat, lon:  coord.lon)
                    .map { weatherForecastResponse in
                        print("weatherForecastResponse")
                        print(weatherForecastResponse)
                        return Action.fetchComplete
                    }
                    .catch { error in
                        Just(Action.fetchError)
                    }
                    .eraseToAnyPublisher()
            )
        case .fetchComplete:
            print("완료")
            return .none
        case .fetchError:
            print("조회 에러")
            return .none
        }
    }
}
