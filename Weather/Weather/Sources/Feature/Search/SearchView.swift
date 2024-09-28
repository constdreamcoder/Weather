//
//  SearchView.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/24/24.
//

import SwiftUI
import Core

/// 검색 화면
struct SearchView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject private var store: Store<SearchReducer.State, SearchReducer.Action>
    
    // MARK: - Body

    var body: some View {
        VStack {
            SearchBar(
                text: Binding(
                    get: { store.state.searchText },
                    set: { store.dispatch(.write(searchText: $0)) }
                )
            )
            .padding(.horizontal, 16)
            
            showingList
        }
        .background(.blue.opacity(0.6))
        .scrollIndicators(.hidden)
        .onAppear {
            store.dispatch(.write(searchText: ""))
        }
    }
    
    // MARK: - Private Methods

    private var showingList: some View {
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
}

#Preview {
    SearchView()
}
