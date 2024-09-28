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
        var showingState: ShowingState = .initial
        var isPresented: Bool = false
        var isConnected: Bool = true
        
        // MARK: - 메인 화면 State
        var result: WeatherForecastResponse? = nil
        var selectedCity: City? = nil
        
        // MARK: - 검색 화면 State
        var searchText: String = ""
        var filteredCityList: [City] = []
    }
    
    enum Action {
        case startNetworkMonitoring
        case showNetworkWaring(isConnected: Bool)
        case initialize
        case refresh
        case present(isPresented: Bool)
        case write(searchText: String)
        case selectCity(city: City)
        case fetchComplete(result: WeatherForecastResponse)
        case fetchError(Error)
    }
    
    @Inject private var weatherService: WeatherServiceProtocol
    @Inject private var cityService: CityServiceProtocol
    @Inject private var networkMonitor: NetworkMonitoringServiceProtocol
    
    private var totalCityList: [City] = []
    
    func reduce(state: inout State, action: Action) -> Effect {
        switch action {
        case .startNetworkMonitoring:
            return startNetworkMonitoringEffet()
            
        case .showNetworkWaring(let isConnected):
            state.isConnected = isConnected
            
        case .initialize:
            return initializeStatesAction(&state)
            
        case .refresh:
            return refreshEffect(&state)
            
        case .present(let isPresented):
            state.isPresented = isPresented
            
        case .write(let searchText):
            searchCitiesAction(&state, searchText: searchText)
            
        case .selectCity(let city):
            return getCityWeatherForecastInfoEffect(&state, selectedCity: city)
            
        case .fetchComplete(let result):
            completeFetchingAction(&state, result: result)
            
        case .fetchError(let error):
            print("조회 에러: ", error)
            
        }
        
        return .none
    }
}

private extension SearchReducer {
    func startNetworkMonitoringEffet() -> Effect {
        return .publisher(
            networkMonitor.isConnected
                .map { isConnected in
                    Action.showNetworkWaring(isConnected: isConnected)
                }
                .eraseToAnyPublisher()
        )
    }
    
    func initializeStatesAction(_ state: inout State) -> Effect {
        
        state.showingState = .loading
        
        self.totalCityList = cityService.loadCityList()
        /// 화면에 보일 도시 목록 초기화
        state.filteredCityList = self.totalCityList
        /// 최초 도시 정보 조회
        guard let initialCity = self.totalCityList.first(where: { $0.id == APIKeys.initialCityId }) else { return .none }
                
        return .publisher(
            Just(.selectCity(city: initialCity)).eraseToAnyPublisher()
        )
    }
    
    func refreshEffect(_ state: inout State) -> Effect {
        guard state.showingState != .initial else { return .none }
        
        if state.result == nil, let selectedCity = state.selectedCity {
            return .publisher(Just(.initialize).eraseToAnyPublisher())
        } else if let selectedCity = state.selectedCity {
            return .publisher(Just(.selectCity(city: selectedCity)).eraseToAnyPublisher())
        }
        
        return .none
    }
    
    func searchCitiesAction(_ state: inout State, searchText: String) {
        state.searchText = searchText
        
        state.filteredCityList = self.totalCityList.filter {
            $0.name.hasPrefix(searchText) || searchText == ""
        }
    }
    
    func getCityWeatherForecastInfoEffect(_ state: inout State, selectedCity: City) -> Effect {
        state.showingState = .loading
        
        state.selectedCity = selectedCity
        return .publisher(
            weatherService.getWeatherForecastInfo(
                lat: selectedCity.coord.lat,
                lon: selectedCity.coord.lon
            )
            .map { weatherForecastResponse in
                Action.fetchComplete(result: weatherForecastResponse)
            }
            .catch { error in
                Just(Action.fetchError(error))
            }
            .eraseToAnyPublisher()
        )
    }
    
    func completeFetchingAction(_ state: inout State, result: WeatherForecastResponse) {
        state.result = result
        state.isPresented = false
        state.showingState = .showingResult
    }
}

extension SearchReducer.State {
    enum ShowingState {
        case initial
        case loading
        case showingResult
    }
}
