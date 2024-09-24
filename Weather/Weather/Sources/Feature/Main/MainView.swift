//
//  MainView.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/24/24.
//

import SwiftUI
import CoreLocation

struct MainView: View {
    @State private var text: String = ""
    @State private var coordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(
        latitude: 37.55272,
        longitude: 126.98101
    )
    
    private let columns: [GridItem] = Array(
        repeating: .init(.flexible(), spacing: 16),
        count: 2
    )
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing:16) {
                    
                    SearchBar(text: $text)
                    
                    VStack(spacing: 4) {
                        Text("Seoul")
                            .font(.system(size: 28))
                        Text("-7°")
                            .font(.system(size: 64))
                        Text("맑음")
                            .font(.system(size: 24))
                        Text("최고 -1° | 최저 -11°")
                    }
                    .foregroundStyle(.white)
                    
                    SectionView(
                        title: "돌풍의 풍속은 최대 4m/s입니다.",
                        enableSeparator: true
                    ) {
                        ScrollView(.horizontal) {
                            HStack(spacing: 24) {
                                HourlyWeatherView()
                                HourlyWeatherView()
                                HourlyWeatherView()
                                HourlyWeatherView()
                                HourlyWeatherView()
                                HourlyWeatherView()
                                HourlyWeatherView()
                            }
                        }
                    }
                    
                    SectionView(
                        title: "5일간의 일기예보",
                        enableSeparator: true
                    ) {
                        ForEach(0..<5) { _ in
                            VStack {
                                DailyWeatherView()
                                
                                Divider()
                                    .background(.white)
                            }
                        }
                    }
                    
                    SectionView(title: "강수량") {
                        MapView(coordinates: $coordinates)
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
    var body: some View {
        VStack(alignment: .center) {
            Text("지금")
            Image(systemName: "sun.max.fill")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 32)
                .foregroundStyle(.yellow)
            Text("-7°")
        }
    }
}

struct DailyWeatherView: View {
    var body: some View {
        HStack {
            Text("오늘")
                .frame(width: 30, alignment: .leading)
            
            Spacer()
            
            Image(systemName: "sun.max.fill")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 32)
                .foregroundStyle(.yellow)
            
            Spacer()
            
            HStack {
                Text("최소: -88°")
                Text("최대: -88°")
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
