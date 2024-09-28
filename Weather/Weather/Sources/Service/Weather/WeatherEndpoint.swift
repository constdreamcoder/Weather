//
//  WeatherEndpoint.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/25/24.
//

import Foundation
import Core

enum WeatherEndpoint {
    case fetchWeatherForecastInfo(lat: Double, lon: Double)
}

extension WeatherEndpoint: EndPointType {
    var baseURL: URL {
        return URL(string: APIKeys.baseURL)!
    }
    
    var path: String {
        switch self {
        case .fetchWeatherForecastInfo:
            return "/onecall"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .fetchWeatherForecastInfo:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .fetchWeatherForecastInfo(let lat, let lon):
            let parameters: Parameters = [
                "lat": "\(lat)", // 위도
                "lon": "\(lon)", // 경도
                "appid": APIKeys.openWeatherMapAPIKey, // API Key
                "exclude": "minutely,alerts", // 제외시킬 API 응답
                "units": "metric", // 온도를 섭씨(°C) 온도로 표시
                "lang": "kr" // 표시 언어 한국어
            ]
            return .requestParameters(parameters)
        }
    }
    
    var headers: HTTPHeaders {
        return [:]
    }
}
