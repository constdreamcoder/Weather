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
    let timezone: String
    let current: CurrentWeather
    let hourly: [HourlyWeather]
    let daily: [DailyWeather]
}

struct WeatherDescription: Decodable {
    let id: Int
    let description: String
    let icon: String
    
    enum CodingKeys: CodingKey {
        case id
        case description
        case icon
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.description = try container.decode(String.self, forKey: .description)
        let icon = try container.decode(String.self, forKey: .icon)
        self.icon = String(icon.prefix(2))
    }
}

// MARK: - 현재 날씨 정보

struct CurrentWeather: Decodable {
    let dt: Int
    let temp: Double
    let humidity: Int
    let clouds: Int
    let windSpeed: Double
    let windGust: Double?
    let weather: [WeatherDescription]
    
    enum CodingKeys: String, CodingKey {
        case dt
        case temp
        case humidity
        case clouds
        case windSpeed = "wind_speed"
        case windGust = "wind_gust"
        case weather
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.dt = try container.decode(Int.self, forKey: .dt)
        self.temp = try container.decode(Double.self, forKey: .temp)
        self.humidity = try container.decode(Int.self, forKey: .humidity)
        self.clouds = try container.decode(Int.self, forKey: .clouds)
        self.windSpeed = try container.decode(Double.self, forKey: .windSpeed)
        self.windGust = try container.decodeIfPresent(Double.self, forKey: .windGust) ?? 0
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
