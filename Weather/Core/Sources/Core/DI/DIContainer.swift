//
//  DIContainer.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/27/24.
//

import Foundation

/// 의존성 주입 컨테이너(Dependency Injection Container)
public final class DIContainer {
    
    private var storage: [String: Any] = [:]
    
    public static let shared = DIContainer()
    private init() {}
    
    public func register<T>(_ object: T, type: T.Type) {
        storage["\(type)"] = object
    }
    
    public func resolve<T>(type: T.Type) -> T {
        guard let object = storage["\(type)"] as? T else {
            fatalError("\(type)에 해당하는 객체가 등록되지 않았습니다.")
        }
        
        return object
    }
}
