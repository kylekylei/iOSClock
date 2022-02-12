//
//  Stopwatch.swift
//  iOSClock
//
//  Created by Kyle Lei on 2022/1/27.
//
import Foundation
import UIKit

struct Lap: Codable {
    let lapIndex: Int
    let lapTimeString: String
    let lapTime: TimeInterval
    
    static func loadLaps() -> [Lap]? {
        let userDefault = UserDefaults.standard
        guard let data = userDefault.data(forKey: "laps") else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode([Lap].self, from: data)
    }
    
    static func saveLaps(_ laps: [Lap]) {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(laps) else { return }
        UserDefaults.standard.set(data, forKey: "laps")
    }
}

enum SetTitle: String {
    case Start
    case Stop, Reset, Lap
    case Pause, Resume, Cancel
}
