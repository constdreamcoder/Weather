//
//  SearchCore.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/25/24.
//

import Foundation
import Combine
import CoreLocation
import Core

final class SearchReducer: ReducerProtocol {
    struct State {
        var isLoading: Bool = false {
            didSet {
                print(isLoading)
            }
        }
        var showAlert: Bool = false
        var isPresented: Bool = false
        var text: String = ""
        var coordinates = CLLocationCoordinate2D()
        var currentWeather = CurrentWeatherSectionModel()
        var hourlyWeather: [HourlyWeatherSectionModel] = []
        var dailyWeather: [DailyWeatherDisplay] = []
        var meteorologicalFactorsUpper: [MeteorologicalFactorUpperDisplay] = []
        var meteorologicalFactorLower = MeteorologicalFactorLowerDisplay()
        
//        struct CurrentWeatherDisplay {
//            var name: String = "Seoul"
//            var temp: Int = 0
//            var description: String = "맑음"
//            var min: Int = 0
//            var max: Int = 0
//            var windGust: Int = 0
//        }
        
        
        
//        struct DailyWeatherDisplay {
//            var dt: Int = 0
//            var min: Int = 0
//            var max: Int = 0
//            var weather: [WeatherDescription] = []
//            var dayOfWeek: String = ""
//        }
        
//        struct MeteorologicalFactorUpperDisplay: Identifiable {
//            let id = UUID()
//            var name: String
//            var value: Int
//        }
        
        struct MeteorologicalFactorLowerDisplay {
            var name: String = ""
            var value: Double = 0
            var additionalValue: Double = 0
        }
        
        var searchText: String = ""
        var filteredCityList: [City] = City.loadCityList()
    }
    
    enum Action {
        case showAlert(isPresented: Bool)
        case onAppear
        case searchError
        case present(isPresented: Bool)
        case write(searchText: String)
        case selectCity(city: City)
        case fetchComplete(result: WeatherForecastResponse)
        case fetchError
    }
    
    @Inject private var weatherService: WeatherServiceProtocol
    
    func reduce(state: inout State, action: Action) -> Effect {
        switch action {
        case .showAlert(let isPresented):
            state.showAlert = isPresented
            
        case .onAppear:
            state.isLoading = true
            
            // TODO: - 추후 Service로 만들기
            /// 최초 도시 정보 조회
            guard let initialCity = City.loadCityList().first (where: { $0.id == APIKeys.initialCityId }) else { return .none }
            
            state.isLoading = false
            return .publisher(
                Just(.selectCity(city: initialCity)).eraseToAnyPublisher()
            )
            
        case .searchError:
            print("유저 위치 검색 오류")
            
        case .present(let isPresented):
            state.isPresented = isPresented
            
        case .write(let searchText):
            state.searchText = searchText
            // TODO: - 추후 Service로 만들기
            state.filteredCityList = City.loadCityList().filter {
                $0.name.hasPrefix(searchText) || searchText == ""
            }
            
        case .selectCity(let city):
            state.isLoading = true
            
            state.currentWeather.name = city.name
            return .publisher(
                weatherService.getWeatherForecastInfo(
                    lat: city.coord.lat,
                    lon: city.coord.lon
                )
                .map { weatherForecastResponse in
                    Action.fetchComplete(result: weatherForecastResponse)
                }
                .catch { error in
                    Just(Action.fetchError)
                }
                .eraseToAnyPublisher()
            )
            
        case .fetchComplete(let result):
            print("완료")
            
            state.currentWeather.description = result.current.weather[0].description
            state.currentWeather.temp = Int(result.current.temp)
            state.currentWeather.min = Int(result.daily[0].temp.min)
            state.currentWeather.max = Int(result.daily[0].temp.max)
            state.currentWeather.windGust = Int(result.current.windGust ?? 0)
            
            state.hourlyWeather = result.hourly.enumerated().compactMap { index, element in
                if index % 3 == 0 {
                    let hour = DateFormatterManager.shared.unixTimeToFormattedTime(
                        element.dt,
                        timeZoneId: result.timezone
                    )
                    return .init(
                        dt: element.dt,
                        temp: Int(element.temp),
                        weather: element.weather,
                        hour: hour
                    )
                }
                return nil
            }
            
            state.hourlyWeather[0].hour = "지금"
            
            state.dailyWeather = result.daily[0..<5].map {
                let dayOfWeek = DateFormatterManager.shared.dayOfWeek(from: $0.dt)
                return .init(
                    dt: $0.dt,
                    min: Int($0.temp.min),
                    max: Int($0.temp.max),
                    weather: $0.weather,
                    dayOfWeek: dayOfWeek
                )
            }
            
            state.dailyWeather[0].dayOfWeek = "오늘"

            state.coordinates.latitude = result.lat
            state.coordinates.longitude = result.lon
            
            let humidity = State.MeteorologicalFactorUpperDisplay(
                name: "습도",
                value: result.current.humidity
            )
            
            let clouds = State.MeteorologicalFactorUpperDisplay(
                name: "구름",
                value: result.current.clouds
            )
            
            state.meteorologicalFactorsUpper = [humidity, clouds]
            
            state.meteorologicalFactorLower.name = "바람 속도"
            state.meteorologicalFactorLower.value = result.current.windSpeed
            state.meteorologicalFactorLower.additionalValue = result.current.windGust ?? 0
            
            state.isPresented = false
            
            state.isLoading = false
            
        case .fetchError:
            print("조회 에러")
            state.currentWeather.name = "Seoul"
            
            state.isLoading = false
        }
        
        return .none
    }
}
