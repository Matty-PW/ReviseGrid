//
//  ContributionGraphCalculator.swift
//  ReviseGrid
//
//  Created by Matty on 05/09/2026.
//

import Foundation

struct DayActivity: Identifiable {
    let date: Date
    let totalMinutes: Int
    let level: Int
    
    var id: Date { date }
}

enum ContributionGraphCalculator {
    static func dayActivities(
    from sessions: [RevisionSession],
    numberOfDays: Int = 371,
    calender: Calendar = .current,
    referenceDate: Date = .now
    ) -> [DayActivity] {
        let today = calender.startOfDay(for: referenceDate)
        
        var totalsByDay: [Date: Int] = [:]
        for session in sessions {
            let day = calender.startOfDay(for: session.date)
            totalsByDay[day, default: 0] += session.durationMinutes
        }
        
        var activities: [DayActivity] = []
        activities.reserveCapacity(numberOfDays)
        
        for offset in stride(from: numberOfDays - 1, through: 0, by: -1) {
            guard let day = calender.date(byAdding: .day, value: -offset, to: today) else { continue }
            let minutes = totalsByDay[day] ?? 0
            activities.append(DayActivity(date: day, totalMinutes: minutes, level: level(forMinutes: minutes)))
        }
        
        return activities
    }
    
    private static func level(forMinutes minutes: Int) -> Int {
        switch minutes {
        case 0: return 0
        case 1..<20: return 1
        case 20..<45: return 2
        case 45..<90: return 3
        default: return 4
        }
    }
}
