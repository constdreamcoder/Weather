//
//  NetworkWorningView.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/29/24.
//

import SwiftUI

struct NetworkWorningView: View {
    var body: some View {
        VStack {
            Image(.noNetwork)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 300)
                .cornerRadius(16, corners: .allCorners)
            
            Text("오프라인 상태인 것 같아요!!")
                .foregroundStyle(.white)
                .font(.system(size: 28, weight: .bold))
            
            Spacer()
                .frame(height: 16)
            
            Text("다시 연결하시면 최신 날씨 정보를 보여드릴게요!")
                .foregroundStyle(.white)
                .font(.system(size: 18, weight: .medium))
                .multilineTextAlignment(.center)
            
            Spacer()
                .frame(height: 80)
        }
    }
}
