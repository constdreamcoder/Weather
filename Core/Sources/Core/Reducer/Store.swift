//
//  Store.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/25/24.
//

import Foundation
import Combine

/// State와 Reducer를 관리하는 Store 정의
public final class Store<State, Action>: ObservableObject {
    
    // MARK: - Properties

    /// 관찰 가능한 Store의 상태값
    @Published public private(set) var state: State
    
    private let reducer: AnyReducer<State, Action>
    
    private let queue = DispatchQueue(label: "StoreQueue", qos: .userInitiated)
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization

    public init<R: ReducerProtocol>(
        intialState: State,
        reducer: R
    ) where R.Action == Action, R.State == State {
        self.state = intialState
        self.reducer = AnyReducer(reducer)
    }
    
    // MARK: - Public Methods

    public func dispatch(_ action: Action) {
        queue.sync { [weak self] in
            guard let self else { return }
            dispatch(&state, action)
        }
    }
    
    // MARK: - Private Methods
    
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
