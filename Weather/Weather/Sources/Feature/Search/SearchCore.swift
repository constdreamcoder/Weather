//
//  SearchCore.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/25/24.
//

import Foundation
import Combine
import CoreLocation
import Core

final class SearchReducer: ReducerProtocol {
    struct State {
        var isLoading: Bool = false {
            didSet {
                print(isLoading)
            }
        }
        var showAlert: Bool = false
        var isPresented: Bool = false
        var result: WeatherForecastResponse? = nil
        var cityName: String = ""
        
        var searchText: String = ""
        var filteredCityList: [City] = City.loadCityList()
    }
    
    enum Action {
        case showAlert(isPresented: Bool)
        case onAppear
        case searchError
        case present(isPresented: Bool)
        case write(searchText: String)
        case selectCity(city: City)
        case fetchComplete(result: WeatherForecastResponse)
        case fetchError
    }
    
    @Inject private var weatherService: WeatherServiceProtocol
    
    func reduce(state: inout State, action: Action) -> Effect {
        switch action {
        case .showAlert(let isPresented):
            state.showAlert = isPresented
            
        case .onAppear:
            state.isLoading = true
            
            // TODO: - 추후 Service로 만들기
            /// 최초 도시 정보 조회
            guard let initialCity = City.loadCityList().first (where: { $0.id == APIKeys.initialCityId }) else { return .none }
            
            state.isLoading = false
            return .publisher(
                Just(.selectCity(city: initialCity)).eraseToAnyPublisher()
            )
            
        case .searchError:
            print("유저 위치 검색 오류")
            
        case .present(let isPresented):
            state.isPresented = isPresented
            
        case .write(let searchText):
            state.searchText = searchText
            // TODO: - 추후 Service로 만들기
            state.filteredCityList = City.loadCityList().filter {
                $0.name.hasPrefix(searchText) || searchText == ""
            }
            
        case .selectCity(let city):
            state.isLoading = true
            
            state.cityName = city.name
            return .publisher(
                weatherService.getWeatherForecastInfo(
                    lat: city.coord.lat,
                    lon: city.coord.lon
                )
                .map { weatherForecastResponse in
                    Action.fetchComplete(result: weatherForecastResponse)
                }
                .catch { error in
                    Just(Action.fetchError)
                }
                .eraseToAnyPublisher()
            )
            
        case .fetchComplete(let result):
            print("완료")
            
            state.result = result
            state.isPresented = false
            state.isLoading = false
            
        case .fetchError:
            print("조회 에러")
            
            state.isLoading = false
        }
        
        return .none
    }
}
