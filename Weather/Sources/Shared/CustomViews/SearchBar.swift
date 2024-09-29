//
//  SearchBar.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/24/24.
//

import SwiftUI

/// 검색바
struct SearchBar: View {
    
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            
            TextField("Search", text: $text)
                .foregroundStyle(.primary)
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                })
            } else {
                EmptyView()
            }
        }
        .padding(8)
        .foregroundStyle(.secondary)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8, corners: .allCorners)
    }
}
