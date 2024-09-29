//
//  CurrentWeatherSection.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/27/24.
//

import SwiftUI

/// 현재 도시 날씨 정보를 보여주는 섹션
struct CurrentWeatherSection: View {
    let model: CurrentWeatherSectionModel
    
    var body: some View {
        VStack(spacing: 4) {
            Text(model.name)
                .font(.system(size: 28))
            Text("\(model.temp)°")
                .font(.system(size: 64))
            Text(model.description)
                .font(.system(size: 24))
            Text("최고 \(model.max)° | 최저 \(model.min)°")
        }
        .foregroundStyle(.white)
    }
}
