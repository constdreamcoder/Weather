//
//  SearchView.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/24/24.
//

import SwiftUI

struct SearchView: View {
    
    @EnvironmentObject private var store: Store<SearchReducer.State, SearchReducer.Action>
    
    var body: some View {
        VStack {
            SearchBar(
                text: Binding(
                    get: { store.state.searchText },
                    set: { store.dispatch(.write(searchText: $0)) }
                )
            )
            .padding(.horizontal, 16)
            
            List {
                ForEach(store.state.filteredCityList, id: \.id) { city in
                    Button(action: {
                        store.dispatch(.selectCity(city: city))
                    }, label: {
                        VStack(alignment: .leading) {
                            Text(city.name)
                                .fontWeight(.bold)
                            Text(city.country)
                        }
                        .foregroundStyle(.white)
                    })
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
