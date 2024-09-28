//
//  Store.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/25/24.
//

import Foundation
import Combine

public final class Store<State, Action>: ObservableObject {
    
    @Published public private(set) var state: State
    
    private let reducer: AnyReducer<State, Action>
    
    private let queue = DispatchQueue(label: "StoreQueue", qos: .userInitiated)
    private var cancellables = Set<AnyCancellable>()
    
    public init<R: ReducerProtocol>(
        intialState: State,
        reducer: R
    ) where R.Action == Action, R.State == State {
        self.state = intialState
        self.reducer = AnyReducer(reducer)
    }
    
    public func dispatch(_ action: Action) {
        queue.sync { [weak self] in
            guard let self else { return }
            dispatch(&state, action)
        }
    }
    
    private func dispatch(_ state: inout State, _ action: Action) {
        let effect = reducer.reduce(state: &state, action: action)

        switch effect {
        case let .publisher(publisher):
            publisher
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: dispatch)
                .store(in: &cancellables)
        case .none:
            break
        }
    }
}
