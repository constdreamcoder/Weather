//
//  EndPointType.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/24/24.
//

import Foundation

typealias HTTPHeaders = [String: String]
typealias Parameters = [String: Any?]

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders { get }
    
    func buildURLRequest() -> URLRequest
}

extension EndPointType {
    func buildURLRequest() -> URLRequest {
        var url: URL = baseURL
        url.appendPathComponent(path)
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.allHTTPHeaderFields = headers
        
        return request
    }
}
