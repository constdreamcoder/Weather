//
//  DailyWeatherSection.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/27/24.
//

import SwiftUI

struct DailyWeatherSection: View {
    let model: DailyWeatherSectionModel
    
    var body: some View {
        MainSectionFrame(
            title: "5일간의 일기예보",
            enableSeparator: true
        ) {
            ForEach(model.dailyWeatherDatas, id: \.dt) { dailyWeatherData in
                VStack {
                    DailyWeatherView(dailyWeatherData: dailyWeatherData)
                    
                    Divider()
                        .background(.white)
                }
            }
        }
    }
}

struct DailyWeatherView: View {
    let dailyWeatherData: DailyWeatherData
    
    var body: some View {
        HStack {
            Text(dailyWeatherData.dayOfWeek)
                .frame(width: 30, alignment: .leading)
            
            Spacer()
            
            Image(dailyWeatherData.weather[0].icon)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 32)
                .foregroundStyle(.yellow)
            
            Spacer()
            
            HStack {
                Text("최소: \(Int(dailyWeatherData.min))°")
                Text("최대: \(Int(dailyWeatherData.max))°")
            }
            .frame(width: 158, alignment: .trailing)
        }
    }
}
