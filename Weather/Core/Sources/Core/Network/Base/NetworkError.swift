//
//  NetworkError.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/24/24.
//

import Foundation

/// 네트워크 에러 정의
enum NetworkError: LocalizedError {
    case invalidURL
    case invalidData
    case invalidStatusCode
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "유효하지 않은 URL입니다."
        case .invalidData:
            return "유효하지 않은 데이터입니다."
        case .invalidStatusCode:
            return "서버 응답 코드 에러"
        }
    }
}
