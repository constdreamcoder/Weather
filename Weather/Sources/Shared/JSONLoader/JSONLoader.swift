//
//  JSONLoader.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/24/24.
//

import Foundation

/// JSON 파일을 로드(Load)하는 객체
struct JSONLoader {
    static func loadJSON(from fileName: String) -> Data? {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json")
        else {
            return nil
        }
        return try? Data(contentsOf: url)
    }
}
