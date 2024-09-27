//
//  Inject.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/27/24.
//

import Foundation

@propertyWrapper
public struct Inject<T> {
    public let wrappedValue: T
    
    public init() {
        self.wrappedValue = DIContainer.shared.resolve(type: T.self)
    }
}
