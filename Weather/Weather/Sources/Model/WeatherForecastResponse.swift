//
//  WeatherForecastResponse.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/25/24.
//

import Foundation

struct WeatherForecastResponse: Decodable {
    let lat: Double
    let lon: Double
    let current: CurrentWeather
    let hourly: [HourlyWeather]
    let daily: [DailyWeather]
}

struct WeatherDescription: Decodable {
    let id: Int
    let description: String
    let icon: String
}

// MARK: - 현재 날씨 정보

struct CurrentWeather: Decodable {
    let dt: Int
    let temp: Double
    let humidity: Int
    let clouds: Int
    let windSpeed: Double
    let weather: [WeatherDescription]
    
    enum CodingKeys: String, CodingKey {
        case dt
        case temp
        case humidity
        case clouds
        case windSpeed = "wind_speed"
        case weather
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.dt = try container.decode(Int.self, forKey: .dt)
        self.temp = try container.decode(Double.self, forKey: .temp)
        self.humidity = try container.decode(Int.self, forKey: .humidity)
        self.clouds = try container.decode(Int.self, forKey: .clouds)
        self.windSpeed = try container.decode(Double.self, forKey: .windSpeed)
        self.weather = try container.decode([WeatherDescription].self, forKey: .weather)
    }
}

// MARK: - 시간당 일기예보

struct HourlyWeather: Decodable {
    let dt: Int
    let temp: Double
    let weather: [WeatherDescription]
}

// MARK: - 일간 일기예보

struct DailyWeather: Decodable {
    let dt: Int
    let temp: DailyTemperature
    let weather: [WeatherDescription]
}

struct DailyTemperature: Decodable {
    let min: Double
    let max: Double
}
