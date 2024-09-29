//
//  ReducerProtocol.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/25/24.
//

import Foundation
import Combine

/// 리듀서(Reducer) 정의 명세
public protocol ReducerProtocol {
    associatedtype State
    associatedtype Action
    
    typealias Effect = EffectType<Action>
    
    func reduce(state: inout State, action: Action) -> Effect
}

/// 비동기 로직 처리
public enum EffectType<Action> {
    case none
    case publisher(AnyPublisher<Action, Never>)
}
