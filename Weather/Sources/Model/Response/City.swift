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
