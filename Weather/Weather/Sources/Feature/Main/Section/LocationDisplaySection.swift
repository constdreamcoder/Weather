//
//  LocationDisplaySection.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/27/24.
//

import SwiftUI

/// 도시 위치를 보여주는 섹션
struct LocationDisplaySection: View {
    let model: LocationDisplaySectionModel
    
    var body: some View {
        MainSectionFrame(title: "강수량") {
            MapView(
                coordinates: .constant(model.coordinate)
            )
            .frame(maxWidth: .infinity)
            .aspectRatio(1, contentMode: .fill)
        }
    }
}
