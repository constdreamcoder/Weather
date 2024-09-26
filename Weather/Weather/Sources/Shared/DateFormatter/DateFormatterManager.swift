//
//  DateFormatterManager.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/26/24.
//

import Foundation
import CoreLocation
import Combine

final class DateFormatterManager {
    static let shared = DateFormatterManager()
    
    private(set) var dateFormatter: DateFormatter
    
    private init() { dateFormatter = DateFormatter() }
    
    /// UNIX 시간을 포맷된 시간을 반환하는 매서드
    func unixTimeToFormattedTime(_ unixTime: Int, timeZoneId: String) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime))
        let dateFormatter = DateFormatterManager.shared.dateFormatter
        dateFormatter.timeZone = TimeZone(identifier: timeZoneId)
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "a h시"
        
        return dateFormatter.string(from: date)
    }
}
