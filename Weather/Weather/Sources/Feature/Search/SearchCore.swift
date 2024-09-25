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
       
    }
    
    enum Action {
        
    }
    
    private let weatherService: WeatherServiceProtocol
    
    init(weatherService: WeatherServiceProtocol) {
        self.weatherService = weatherService
    }
    
    func reduce(state: inout State, action: Action) -> Effect {
        return .none
    }
}
