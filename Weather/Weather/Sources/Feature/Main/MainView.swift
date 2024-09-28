//
//  MainView.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/24/24.
//

import SwiftUI
import Core

/// 메인 화면
struct MainView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject private var store: Store<SearchReducer.State, SearchReducer.Action>
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            Color.blue.opacity(0.6)
                .ignoresSafeArea()
            
            if store.state.isConnected {
                content
                    .onAppear {
                        store.dispatch(.refresh)
                    }
            } else {
                NetworkWorningView()
            }
        }
        .onAppear {
            store.dispatch(.startNetworkMonitoring)
            store.dispatch(.initialize)
        }
        .animation(.easeInOut, value: store.state.isConnected)
    }
    
    // MARK: - Private Methods
    
    @ViewBuilder
    private var content: some View {
        switch store.state.showingState {
        case .initial:
            Text("")
        case .loading:
            ProgressView()
                .progressViewStyle(.circular)
                .tint(.white)
                .controlSize(.large)
        case .showingResult:
            mainContents
        }
    }
    
    /// 메인 화면 컨텐츠 표시 뷰
    private var mainContents: some View {
        ScrollView {
            VStack(spacing:16) {
                
                SearchBar(text: .constant(""))
                    .disabled(true)
                    .onTapGesture {
                        store.dispatch(.present(isPresented: true))
                    }
                
                CurrentWeatherSection(model: .init(from: store.state.result, with: store.state.selectedCity))
                
                HourlyWeatherSection(model: .init(from: store.state.result))
                
                DailyWeatherSection(model: .init(from: store.state.result))
                
                LocationDisplaySection(model: .init(from: store.state.result))
                
                MeteorologicalFactorSection(result: store.state.result)
            }
        }
        .padding(.horizontal, 16)
        .scrollIndicators(.hidden)
        .fullScreenCover(
            isPresented: Binding(
                get: { store.state.isPresented },
                set: { store.dispatch(.present(isPresented: $0)) }
            )
        ) {
            SearchView()
        }
    }
}

// MARK: - Preview

#Preview {
    MainView()
}
