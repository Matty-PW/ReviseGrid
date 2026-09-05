//
//  StreakCalculator.swift
//  ReviseGrid
//
//  Created by Matty on 05/09/2026.
//

import Foundation

enum StreakCalculator {
    static func currentStreak(from activities: [DayActivity]) -> Int {
        guard !activities.isEmpty else { return 0 }
        
        var days = activities
        // if today has no activity logged yet dont break streak
        // drop it and count backward from yesterday instead
        if let today = days.last, today.totalMinutes == 0 {
            days.removeLast()
        }
        
        var streak = 0
        for day in days.reversed() {
            if day.totalMinutes > 0 {
                streak += 1
            } else {
                break
            }
        }
        return streak
    }
}
