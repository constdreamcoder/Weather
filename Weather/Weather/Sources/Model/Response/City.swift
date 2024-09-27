//
//  City.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/24/24.
//

import Foundation

struct City: Decodable {
    let id: Int
    let name: String
    let country: String
    let coord: Coordinate
}

struct Coordinate: Decodable {
    let lon: Double
    let lat: Double
}

extension City {
    static func loadCityList() -> [City] {
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
