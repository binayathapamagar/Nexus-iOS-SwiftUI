//
//  DateExtension.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-09-26.
//

import Foundation

extension Date {
    
    static func getJoinedAtDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"  // eg: September 18, 2024
        return formatter.string(from: Date())
    }
    
}
