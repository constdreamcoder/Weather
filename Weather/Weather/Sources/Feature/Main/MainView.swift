//
//  MainView.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/24/24.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject private var store: Store<SearchReducer.State, SearchReducer.Action>
    
    private let columns: [GridItem] = Array(
        repeating: .init(.flexible(), spacing: 16),
        count: 2
    )
    
    var body: some View {
        ScrollView {
            VStack(spacing:16) {
                
                SearchBar(text: .constant(""))
                    .disabled(true)
                    .onTapGesture {
                        store.dispatch(.present(isPresented: true))
                    }
                
                VStack(spacing: 4) {
                    Text(store.state.currentWeather.name)
                        .font(.system(size: 28))
                    Text("\(store.state.currentWeather.temp)°")
                        .font(.system(size: 64))
                    Text(store.state.currentWeather.description)
                        .font(.system(size: 24))
                    Text("최고 \(store.state.currentWeather.max)° | 최저 \(store.state.currentWeather.min)°")
                }
                .foregroundStyle(.white)
                
                SectionView(
                    title: "돌풍의 풍속은 최대 \(store.state.currentWeather.windGust)m/s입니다.",
                    enableSeparator: true
                ) {
                    ScrollView(.horizontal) {
                        LazyHStack(spacing: 24) {
                            ForEach(store.state.hourlyWeather, id: \.dt) { hourlyWeather in
                                HourlyWeatherView(hourlyWeather: hourlyWeather)
                            }
                        }
                    }
                }
                
                SectionView(
                    title: "5일간의 일기예보",
                    enableSeparator: true
                ) {
                    ForEach(store.state.dailyWeather, id: \.dt) { dailyWeather in
                        VStack {
                            DailyWeatherView(dailyWeather: dailyWeather)
                            
                            Divider()
                                .background(.white)
                        }
                    }
                }
                
                SectionView(title: "강수량") {
                    MapView(
                        coordinates: .constant(store.state.coordinates)
                    )
                    .frame(maxWidth: .infinity)
                    .aspectRatio(1, contentMode: .fill)
                }
                
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(0..<4) { _ in
                        WeatherInfoView()
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .background(.blue.opacity(0.6))
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

struct HourlyWeatherView: View {
    let hourlyWeather: SearchReducer.State.HourlyWeatherDisplay
    
    var body: some View {
        VStack(alignment: .center) {
            Text(hourlyWeather.hour)
            
            Image(hourlyWeather.weather[0].icon)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 32)
                .foregroundStyle(.yellow)
            
            Text("\(hourlyWeather.temp)°")
        }
    }
}

struct DailyWeatherView: View {
    let dailyWeather: SearchReducer.State.DailyWeatherDisplay
    
    var body: some View {
        HStack {
            Text(dailyWeather.dayOfWeek)
                .frame(width: 30, alignment: .leading)
            
            Spacer()
            
            Image(dailyWeather.weather[0].icon)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 32)
                .foregroundStyle(.yellow)
            
            Spacer()
            
            HStack {
                Text("최소: \(Int(dailyWeather.min))°")
                Text("최대: \(Int(dailyWeather.max))°")
            }
            .frame(width: 158, alignment: .trailing)
        }
    }
}

struct WeatherInfoView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(.blue)
            .aspectRatio(1.0, contentMode: .fit)  // 1:1 비율 유지
            .overlay(alignment: .topLeading) {
                Text("습도")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
            }
            .overlay(alignment: .leading) {
                Text("56%")
                    .font(.largeTitle)
                    .padding(.horizontal, 18)
            }
            .overlay(alignment: .bottomLeading) {
                Text("2%")
                    .padding(16)
            }
            .foregroundStyle(.white)
    }
}
