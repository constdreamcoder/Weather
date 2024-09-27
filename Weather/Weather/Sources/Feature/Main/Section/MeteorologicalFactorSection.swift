//
//  MeteorologicalFactorSection.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/27/24.
//

import SwiftUI

struct MeteorologicalFactorSection: View {
    let result: WeatherForecastResponse?
    
    private let columns: [GridItem] = Array(
        repeating: .init(.flexible(), spacing: 16),
        count: 2
    )
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            
            MeteorologicalFactorUpperSection(model: .init(from: result))
            
            MeteorologicalFactorLowerSection(model: .init(from: result))
        }
    }
}

// MARK: - MeteorologicalFactorUpperSection

struct MeteorologicalFactorUpperSection: View {
    let model: MeteorologicalFactorUpperSectionModel
    
    var body: some View {
        ForEach(model.meteorologicalFactorsUpperDatas, id: \.id) { factorData in
            WeatherInfoView(
                factorName: factorData.name,
                value: "\(factorData.value)%",
                additionalValue: ""
            )
        }
    }
}

struct WeatherInfoView: View {
    
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

// MARK: - MeteorologicalFactorLowerSection

struct MeteorologicalFactorLowerSection: View {
    let model: MeteorologicalFactorLowerSectionModel
    
    var body: some View {
        WeatherInfoView(
            factorName: model.name,
            value: "\(model.value)m/s",
            additionalValue: "\(model.additionalValue)m/s"
        )
    }
}

