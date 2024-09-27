//
//  LocationDisplaySection.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/27/24.
//

import SwiftUI

struct LocationDisplaySection: View {
    let model: LocationDisplaySectionModel
    
    var body: some View {
        SectionView(title: "강수량") {
            MapView(
                coordinates: .constant(model.coordinate)
            )
            .frame(maxWidth: .infinity)
            .aspectRatio(1, contentMode: .fill)
        }
    }
}
