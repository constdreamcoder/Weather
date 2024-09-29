//
//  CityService.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/27/24.
//

import Foundation
import Core

protocol CityServiceProtocol {
    func loadCityList() -> [City]
}

/// 도시 목록 조회 서비스
struct CityService: CityServiceProtocol {
    func loadCityList() -> [City] {
        do {
            guard let data = JSONLoader.loadJSON(from: "citylist")
            else {
                return []
            }
            
            let decoder = JSONDecoder()
            return try decoder.decode([City].self, from: data)
        } catch {
            return []
        }
    }
}
