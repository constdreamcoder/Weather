//
//  AnyReducer.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/25/24.
//

import Foundation
import Combine

/// Store를 생성할 때, `ReducerProtocol`을 제네릭 타입추론이 가능하게 하기 위한 `AnyReducer`타입
struct AnyReducer<State, Action>: ReducerProtocol {
    
    private let _reduce: (inout State, Action) -> Effect
    
    init<R: ReducerProtocol>(
        _ reducer: R
    ) where R.State == State, R.Action == Action {
        self._reduce = reducer.reduce
    }
    
    func reduce(state: inout State, action: Action) -> EffectType<Action> {
        return _reduce(&state, action)
    }
}
