//
//  WeatherInfoFrame.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/29/24.
//

import SwiftUI

/// 기상 요소(습도, 구름, 바람) 정보 섹션 기본 Frame
struct WeatherInfoFrame: View {
    
    let factorName: String
    let value: String
    let additionalValue: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(.blue)
            .aspectRatio(1.0, contentMode: .fit)
            .overlay(alignment: .topLeading) {
                Text(factorName)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
            }
            .overlay(alignment: .leading) {
                Text(value)
                    .font(.largeTitle)
                    .padding(.horizontal, 18)
            }
            .overlay(alignment: .bottomLeading) {
                Text(additionalValue)
                    .padding(16)
            }
            .foregroundStyle(.white)
    }
}
