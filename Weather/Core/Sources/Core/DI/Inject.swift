//
//  Inject.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/27/24.
//

import Foundation

/// Property Wrapper를 통한 의존성 주입 정의
@propertyWrapper
public struct Inject<T> {
    public let wrappedValue: T
    
    public init() {
        self.wrappedValue = DIContainer.shared.resolve(type: T.self)
    }
}
