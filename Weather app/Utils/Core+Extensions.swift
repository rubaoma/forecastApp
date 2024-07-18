//
//  Core+Extensions.swift
//  Weather app
//
//  Created by Rubens Moura Augusto on 15/07/24.
//

import Foundation

extension Int {
    func toWeekdayName() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE" // EE represesnts the full weekday name
        
        return dateFormatter.string(from: date)
    }
    
    func toHourFormat() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm" // HH:mm represents the 24-hour format
        
        return dateFormatter.string(from: date)
    }
    
    func isDayTime() -> Bool {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let hour = Calendar.current.component(.hour, from: date)
        
        let daystartHour = 6
        let dayEndHour = 18
        
        return hour >= daystartHour && hour < dayEndHour
    }
}

extension Double {
    func toCelsius () -> String {
        "\(Int(self))ºC"
    }
}
