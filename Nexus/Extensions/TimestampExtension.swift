//
//  TimestampExtension.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-10-10.
//

import Firebase

extension Timestamp {
    
    // Converts the Firebase `Timestamp` to a relative time string (e.g., "5m", "1d").
    func timeAgoDisplay() -> String {
        let date = self.dateValue()
        let secondsAgo = Int(Date().timeIntervalSince(date))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 30 * day
        let year = 365 * day
        
        switch secondsAgo {
        case 0..<minute:
            return "\(secondsAgo)s"
        case minute..<hour:
            return "\(secondsAgo / minute)m"
        case hour..<day:
            return "\(secondsAgo / hour)h"
        case day..<week:
            return "\(secondsAgo / day)d"
        case week..<month:
            return "\(secondsAgo / week)w"
        case month..<year:
            return "\(secondsAgo / month)m"
        default:
            return "\(secondsAgo / year)y"
        }
    }
    
//    func timeAgoDisplay() -> String {
//        let formatter = DateComponentsFormatter()
//        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth, .month, .year]
//        formatter.maximumUnitCount = 1
//        formatter.unitsStyle = .abbreviated
//        return formatter.string(from: self.dateValue(), to: Date()) ?? ""
//    }
    
}
