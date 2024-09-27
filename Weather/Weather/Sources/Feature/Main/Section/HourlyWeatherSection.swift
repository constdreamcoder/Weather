//
//  HourlyWeatherSection.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/27/24.
//

import SwiftUI

struct HourlyWeatherSection: View {
    let model: HourlyWeatherSectionModel
    
    var body: some View {
        SectionView(
            title: "돌풍의 풍속은 최대 \(model.windGust)m/s입니다.",
            enableSeparator: true
        ) {
            ScrollView(.horizontal) {
                LazyHStack(spacing: 24) {
                    ForEach(model.hourlyWeatherDatas, id: \.dt) { hourlyWeatherData in
                        HourlyWeatherView(hourlyWeatherData: hourlyWeatherData)
                    }
                }
            }
        }
    }
}

struct HourlyWeatherView: View {
    let hourlyWeatherData: HourlyWeatherData
    
    var body: some View {
        VStack(alignment: .center) {
            Text(hourlyWeatherData.hour)
            
            Image(hourlyWeatherData.weather[0].icon)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 32)
                .foregroundStyle(.yellow)
            
            Text("\(hourlyWeatherData.temp)°")
        }
    }
}
