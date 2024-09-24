//
//  NetworkRouter.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/25/24.
//

import Foundation
import Combine

protocol NetworkRouterProtocol {
    func request<T: Decodable>(with endPoint: EndPointType, type: T.Type) -> AnyPublisher<T, Error>
}

final class NetworkRouter: NetworkRouterProtocol {
    
    private let session: URLSession
    private let decoder = JSONDecoder()
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    /// 네트워크 요청 생성
    func request<T: Decodable>(with endPoint: EndPointType, type: T.Type) -> AnyPublisher<T, Error> {
        let urlRequest = endPoint.buildURLRequest()
        
        return requestData(with: urlRequest.url!)
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    func requestData(with url: URL) -> AnyPublisher<Data, Error> {
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
