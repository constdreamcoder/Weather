//
//  DIContainer.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/27/24.
//

import Foundation

final class DIContainer {
    
    private var storage: [String: Any] = [:]
    
    static let shared = DIContainer()
    private init() {}
    
    func register<T>(_ object: T, type: T.Type) {
        storage["\(type)"] = object
    }
    
    func resolve<T>(type: T.Type) -> T {
        guard let object = storage["\(type)"] as? T else {
            fatalError("\(type)에 해당하는 객체가 등록되지 않았습니다.")
        }
        
        return object
    }
}
