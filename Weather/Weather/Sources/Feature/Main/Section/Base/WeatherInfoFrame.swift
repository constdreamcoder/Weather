//
//  WeatherInfoFrame.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/29/24.
//

import SwiftUI

struct WeatherInfoFrame: View {
    
    let factorName: String
    let value: String
    let additionalValue: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(.blue)
            .aspectRatio(1.0, contentMode: .fit)  // 1:1 비율 유지
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
