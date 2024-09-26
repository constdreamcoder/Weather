//
//  AppEnvironment.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/27/24.
//

import Foundation

struct AppEnvironment {
    let container = DIContainer.shared

    func registerDependencies() {
        container.register(NetworkRouter(), type: NetworkRouterProtocol.self)
        
        container.register(WeatherService(), type: WeatherServiceProtocol.self)
        container.register(LocationService(), type: LocationServiceProtocol.self)
    }
}
