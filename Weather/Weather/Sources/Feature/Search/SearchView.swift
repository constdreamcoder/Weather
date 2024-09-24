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
            
            List(0..<20) { _ in
                VStack(alignment: .leading) {
                    Text("Seoul")
                        .fontWeight(.bold)
                    Text("KR")
                }
                .foregroundStyle(.white)
                .listRowBackground(Color.blue.opacity(0))
                .listRowSeparatorTint(.white)
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
