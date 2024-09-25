//
//  WeatherApp.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/24/24.
//

import SwiftUI

@main
struct WeatherApp: App {
    var body: some Scene {
        WindowGroup {
            SearchView()
                .environmentObject(
                    Store(
                        intialState: SearchReducer.State(),
                        reducer: SearchReducer(
                            weatherService: WeatherService(router: NetworkRouter())
                        )
                    )
                )
        }
    }
}
