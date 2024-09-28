//
//  NetworkRouter.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/25/24.
//

import Foundation
import Combine

public protocol NetworkRouterProtocol {
    func request<T: Decodable>(with endPoint: EndPointType, type: T.Type) -> AnyPublisher<T, Error>
}

/// 네트워크 요청 Router 정의
public final class NetworkRouter: NetworkRouterProtocol {
    
    private let session: URLSession
    private let decoder = JSONDecoder()
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    /// 네트워크 요청
    public func request<T: Decodable>(with endPoint: EndPointType, type: T.Type) -> AnyPublisher<T, Error> {
        let urlRequest = endPoint.buildURLRequest()
        
        return requestData(with: urlRequest.url!)
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    /// 네트워크 응답 처리
    private func requestData(with url: URL) -> AnyPublisher<Data, Error> {
        return session.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      200..<300 ~= httpResponse.statusCode
                else {
                    throw NetworkError.invalidStatusCode
                }
                return data
            }
            .eraseToAnyPublisher()
    }
}
