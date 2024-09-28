//
//  MeteorologicalFactorSection.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/27/24.
//

import SwiftUI

/// 현재 습도 / 구름 / 바람 정보를 보여주는 섹션
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

/// 현재 습도 / 구름 정보를 보여주는 섹션
struct MeteorologicalFactorUpperSection: View {
    let model: MeteorologicalFactorUpperSectionModel
    
    var body: some View {
        ForEach(model.meteorologicalFactorsUpperDatas, id: \.id) { factorData in
            WeatherInfoFrame(
                factorName: factorData.name,
                value: "\(factorData.value)%",
                additionalValue: ""
            )
        }
    }
}

// MARK: - MeteorologicalFactorLowerSection

/// 현재 바람 정보를 보여주는 섹션
struct MeteorologicalFactorLowerSection: View {
    let model: MeteorologicalFactorLowerSectionModel
    
    var body: some View {
        WeatherInfoFrame(
            factorName: model.name,
            value: "\(model.value)m/s",
            additionalValue: "\(model.additionalValue)m/s"
        )
    }
}

