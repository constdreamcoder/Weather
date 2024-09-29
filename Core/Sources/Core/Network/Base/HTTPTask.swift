//
//  HTTPTask.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/24/24.
//

import Foundation

/// HTTP Task 정의
public enum HTTPTask {
    case requestPlain
    case requestParameters(_ queryParameters: Parameters)
}
