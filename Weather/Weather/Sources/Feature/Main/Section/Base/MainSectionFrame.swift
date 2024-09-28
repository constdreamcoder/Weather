//
//  MainSectionFrame.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/29/24.
//

import SwiftUI

struct MainSectionFrame<Content>: View where Content : View {
    
    private let title: String
    private let enableSeparator: Bool
    private let content: Content
    
    init(
        title: String = "",
        enableSeparator: Bool = false,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.enableSeparator = enableSeparator
        self.content = content()
    }
    
    var body: some View {
        VStack {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if enableSeparator {
                Divider()
                    .background(.white)
            }
            
            content
        }
        .foregroundStyle(.white)
        .padding(16)
        .background(.blue)
        .cornerRadius(16, corners: .allCorners)
    }
}
