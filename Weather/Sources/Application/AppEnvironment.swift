//
//  AppEnvironment.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/27/24.
//

import Foundation
import Core

/// 의존성 주입을 위한 Environment
struct AppEnvironment {
    let container = DIContainer.shared

    func registerDependencies() {
        container.register(NetworkRouter(), type: NetworkRouterProtocol.self)
        
        container.register(NetworkMonitoringService(), type: NetworkMonitoringServiceProtocol.self)
        
        container.register(WeatherService(), type: WeatherServiceProtocol.self)
        container.register(CityService(), type: CityServiceProtocol.self)
    }
}
