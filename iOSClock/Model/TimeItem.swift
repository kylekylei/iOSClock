//
//  TimeItem.swift
//  iOSClock
//
//  Created by Kyle Lei on 2022/1/13.
//

import Foundation

struct City: Codable {
    var identifier: String
    init(identifier: String) {
        self.identifier = identifier
    }
    
    var cityName: String {
        String(identifier.split(separator: "/").last!).replacingOccurrences(of: "_", with: " ")
    }

    var relativeHours: String {
        let timeInterval = TimeZone(identifier: identifier)!.secondsFromGMT() - TimeZone.current.secondsFromGMT()
        let hours = timeInterval / 3600
        return "\(hours.signum() == 1 ? "+" : "")\(String(format: "%.1d", hours))\(abs(hours) == 1 ? "HR" : "HRS")"
    }

    var relativeDate: String {
        let dateFormater = DateFormatter()
        dateFormater.timeStyle = .none
        dateFormater.dateStyle = .medium
        dateFormater.timeZone = TimeZone(identifier: identifier)
        dateFormater.doesRelativeDateFormatting = true
        return dateFormater.string(from: .now)
    }    

    var localTime: String {
        let dateFormater = DateFormatter()
        dateFormater.timeStyle = .short
        dateFormater.timeZone = TimeZone(identifier: identifier)
        dateFormater.dateFormat = "HH:mm"
        return dateFormater.string(from: .now)
    }
    
    static func loadCities() -> [City]? {
        let userDefault = UserDefaults.standard
        guard let data = userDefault.data(forKey: "cities") else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode([City].self, from: data)
    }
    
    static func saveCities(_ cities: [City]) {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(cities) else { return }
        UserDefaults.standard.set(data, forKey: "cities")
    }    
}


