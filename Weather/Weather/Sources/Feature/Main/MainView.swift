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
            
            content
                .onAppear {
                    store.dispatch(.onAppear)
                }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if store.state.isLoading {
            ProgressView()
                .progressViewStyle(.circular)
                .tint(.white)
                .controlSize(.large)
        } else {
            ScrollView {
                VStack(spacing:16) {
                    
                    SearchBar(text: .constant(""))
                        .disabled(true)
                        .onTapGesture {
                            store.dispatch(.present(isPresented: true))
                        }
                    
                    CurrentWeatherSection(model: .init(from: store.state.result, with: store.state.cityName))
                    
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
            .alert(
                "위치 정보 이용",
                isPresented: Binding(
                    get: { store.state.showAlert },
                    set: { store.dispatch(.showAlert(isPresented: $0)) }
                ),
                actions: {
                    Button("이동") {
                        if let setting = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(setting)
                        }
                    }
                    Button("취소", role: .cancel) {}
                },
                message: {
                    Text("위치 서비스를 사용할 수 없습니다. 기기 '설정>개인정보 보호'에서 위치 서비스를 켜주세요")
                }
            )
        }
    }
    
}

#Preview {
    MainView()
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






