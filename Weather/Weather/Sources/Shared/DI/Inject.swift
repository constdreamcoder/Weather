//
//  Inject.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/27/24.
//

import Foundation

@propertyWrapper
struct Inject<T> {
    let wrappedValue: T
    
    init() {
        self.wrappedValue = DIContainer.shared.resolve(T.self)
    }
}
