//
//  MainView.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/24/24.
//

import SwiftUI
import Core

struct MainView: View {
    
    @EnvironmentObject private var store: Store<SearchReducer.State, SearchReducer.Action>
    
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
            MainContentView()
        }
    }
}

#Preview {
    MainView()
}

struct MainContentView: View {

    @EnvironmentObject private var store: Store<SearchReducer.State, SearchReducer.Action>

    var body: some View {
        ScrollView {
            VStack(spacing:16) {
                
                SearchBar(text: .constant(""))
                    .disabled(true)
                    .onTapGesture {
                        store.dispatch(.present(isPresented: true))
                    }
                
                CurrentWeatherSection(model: .init(from: store.state.result, with: store.state.selectedCity?.name ?? ""))
                
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

struct SectionView<Content>: View where Content : View {
    
    private let title: String
    private let enableSeparator: Bool
    private let content: Content
    
    init(
        title: String = "",
        enableSeparator: Bool = false,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.enableSeparator = enableSeparator
        self.content = content()
    }
    
    var body: some View {
        VStack {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if enableSeparator {
                Divider()
                    .background(.white)
            }
            
            content
        }
        .foregroundStyle(.white)
        .padding(16)
        .background(.blue)
        .cornerRadius(16, corners: .allCorners)
    }
}

struct NetworkWorningView: View {
    var body: some View {
        VStack {
            Image(.noNetwork)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 300)
                .cornerRadius(16, corners: .allCorners)
            
            Text("오프라인 상태인 것 같아요!!")
                .foregroundStyle(.white)
                .font(.system(size: 28, weight: .bold))
            
            Spacer()
                .frame(height: 16)
            
            Text("다시 연결하시면 최신 날씨 정보를 보여드릴게요!")
                .foregroundStyle(.white)
                .font(.system(size: 18, weight: .medium))
                .multilineTextAlignment(.center)
            
            Spacer()
                .frame(height: 80)
        }
    }
}
