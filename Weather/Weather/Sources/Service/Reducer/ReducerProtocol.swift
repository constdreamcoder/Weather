//
//  ReducerProtocol.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/25/24.
//

import Foundation
import Combine

protocol ReducerProtocol {
    associatedtype State
    associatedtype Action
    
    typealias Effect = EffectType<Action>
    
    func reduce(state: inout State, action: Action) -> Effect
}

enum EffectType<Action> {
    case none
    case publisher(AnyPublisher<Action, Never>)
}
