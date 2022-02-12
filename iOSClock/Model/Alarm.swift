//
//  Alarm.swift
//  iOSClock
//
//  Created by Kyle Lei on 2022/1/19.
//

import Foundation

struct AlarmClock: Codable {

    var time = Date.now
    var repeatDays: [RepeatDay] = {
        var repeatDays = [RepeatDay]()
        for weekdaySymbol in weekdaySymbols {
            let repeatDay = RepeatDay(weekDay: weekdaySymbol, isRepeat: true)
            repeatDays.append(repeatDay)
        }
        return repeatDays
    }()
     
    var label: String = "Alarm"
    var sound: String = "Radar"
    var snooze: Bool = true
    var isOn: Bool = true
    
    //info
    var timeStr: String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "HH:mm"
        return dateformatter.string(from: time)
    }
    var description: String {
        "\(label), \(repeatDayDescription)"
    }
    
    var repeatDayDescription: String {
        let repeatDaysCount: Int = repeatDays.filter { $0.isRepeat == true }.count
        
        switch repeatDaysCount {
        case 0: return "Never"
        case repeatDays.count: return "Every Day"
        default:
            var repeatDayDescription = [String]()
            for (index, repeatDay) in repeatDays.enumerated() {
                if repeatDay.isRepeat == true {
                    let shortSymbol = shortWeekdaySymbols[index]
                    repeatDayDescription.append(shortSymbol)
                }
            }
            return String(repeatDayDescription.joined(separator: " "))
        }
    }
    
    var weekdaySet: [Int] {        
        var weekdaySet = [Int]()
        for (index, repeatDay) in repeatDays.enumerated() {
            if repeatDay.isRepeat == true {
                weekdaySet.append(index+1)
            }
        }
        return weekdaySet
    }
   
    static func loadAlarmClocks() -> [AlarmClock]? {
        let userDefault = UserDefaults.standard
        guard let data = userDefault.data(forKey: "alarmClocks") else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode([AlarmClock].self, from: data)
    }
    
    static func saveAlarmClocks(_ alarmClocks: [AlarmClock]) {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(alarmClocks) else { return }
        UserDefaults.standard.set(data, forKey: "alarmClocks")
    }
   
}

struct RepeatDay: Codable {
    var weekDay: String
    var isRepeat: Bool
}



let ringTones = ["Radar", "Marimba", "Opening", "Waves", "XyloPhone"]


let weekdaySymbols: [String] = {
    let formatter = DateFormatter()
    guard let weekdaySymbols = formatter.weekdaySymbols else { return [""] }
    return weekdaySymbols
}()

let shortWeekdaySymbols: [String] = {
   let formatter = DateFormatter()
    guard let shortWeekdaySymbols = formatter.shortWeekdaySymbols else {return [""]}
    return shortWeekdaySymbols
}()


