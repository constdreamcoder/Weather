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
        case searchError // 삭제 예정
        case present(isPresented: Bool)
        case write(searchText: String)
        case selectCity(city: City)
        case fetchComplete(result: WeatherForecastResponse)
        case fetchError
    }
    
    @Inject private var weatherService: WeatherServiceProtocol
    @Inject private var cityService: CityServiceProtocol
    
    private var totalCityList: [City] = []
    
    func reduce(state: inout State, action: Action) -> Effect {
        switch action {
        case .showAlert(let isPresented):
            state.showAlert = isPresented
            
        case .onAppear:
            return initializeStatesAction(&state)
            
        // TODO: - 삭제 예정
        case .searchError:
            print("유저 위치 검색 오류")
            
        case .present(let isPresented):
            state.isPresented = isPresented
            
        case .write(let searchText):
            filterCities(&state, searchText: searchText)
            
        case .selectCity(let city):
            return getCityWeatherForecastInfoEffect(&state, selectedCity: city)
            
        case .fetchComplete(let result):
            print("완료")
            completeFetching(&state, result: result)
            
        case .fetchError:
            print("조회 에러")
            state.isLoading = false
        }
        
        return .none
    }
}

private extension SearchReducer {
    func initializeStatesAction(_ state: inout State) -> Effect {
        
        state.isLoading = true
        
        self.totalCityList = cityService.loadCityList()
        
        /// 화면에 보일 도시 목록 초기화
        state.filteredCityList = self.totalCityList
        
        /// 최초 도시 정보 조회
        guard let initialCity = self.totalCityList.first(where: { $0.id == APIKeys.initialCityId }) else { return .none }
        
        state.isLoading = false
        
        return .publisher(
            Just(.selectCity(city: initialCity)).eraseToAnyPublisher()
        )
    }
    
    func filterCities(_ state: inout State, searchText: String) {
        state.searchText = searchText
        
        state.filteredCityList = self.totalCityList.filter {
            $0.name.hasPrefix(searchText) || searchText == ""
        }
    }
    
    func getCityWeatherForecastInfoEffect(_ state: inout State, selectedCity: City) -> Effect {
        state.isLoading = true
        
        state.cityName = selectedCity.name
        return .publisher(
            weatherService.getWeatherForecastInfo(
                lat: selectedCity.coord.lat,
                lon: selectedCity.coord.lon
            )
            .map { weatherForecastResponse in
                Action.fetchComplete(result: weatherForecastResponse)
            }
            .catch { error in
                Just(Action.fetchError)
            }
            .eraseToAnyPublisher()
        )
    }
    
    func completeFetching(_ state: inout State, result: WeatherForecastResponse) {
        state.result = result
        state.isPresented = false
        state.isLoading = false
    }
}
