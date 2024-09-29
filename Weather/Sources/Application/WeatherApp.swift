//
//  WeatherApp.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/24/24.
//

import SwiftUI
import Core

@main
struct WeatherApp: App {
    
    init() {
        AppEnvironment().registerDependencies()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(
                    Store(
                        intialState: SearchReducer.State(),
                        reducer: SearchReducer()
                    )
                )
        }
    }
}
