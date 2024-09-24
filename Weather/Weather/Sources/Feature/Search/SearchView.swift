//
//  SearchView.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/24/24.
//

import SwiftUI

struct SearchView: View {
    @State private var text: String = ""
    var body: some View {
        VStack {
            SearchBar(text: $text)
                .padding(.horizontal, 16)
            
            List {
                ForEach(City.loadCityList(), id: \.id) { city in
                    VStack(alignment: .leading) {
                        Text(city.name)
                            .fontWeight(.bold)
                        Text(city.country)
                    }
                    .foregroundStyle(.white)
                    .listRowBackground(Color.blue.opacity(0))
                    .listRowSeparatorTint(.white)
                }
                
            }
            .padding(.trailing, 16)
            .listStyle(.plain)
        }
        .background(.blue.opacity(0.6))
        .scrollIndicators(.hidden)
    }
}

#Preview {
    SearchView()
}
