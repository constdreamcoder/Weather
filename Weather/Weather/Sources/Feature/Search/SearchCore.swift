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
        var isLoading: Bool = false
        var showAlert: Bool = false
        var isPresented: Bool = false
        
        // MARK: - 메인 화면 State
        var result: WeatherForecastResponse? = nil
        var cityName: String = ""
        
        // MARK: - 검색 화면 State
        var searchText: String = ""
        var filteredCityList: [City] = []
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
    @Inject private var cityService: CityServiceProtocol
    
    func reduce(state: inout State, action: Action) -> Effect {
        switch action {
        case .showAlert(let isPresented):
            state.showAlert = isPresented
            
        case .onAppear:
            
            state.isLoading = true
            
            let initialCityList = cityService.loadCityList()
            
            /// 화면에 보일 도시 목록 초기화
            state.filteredCityList = initialCityList
            
            /// 최초 도시 정보 조회
            guard let initialCity = initialCityList.first(where: { $0.id == APIKeys.initialCityId }) else { return .none }
            
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
            
            state.filteredCityList = cityService.loadCityList().filter {
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
