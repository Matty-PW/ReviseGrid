//
//  RevisionWidgetProvider.swift
//  RevisionWidgetExtension
//
//  Created by Matty on 12/09/2026.
//

import WidgetKit
import SwiftData

struct RevisionWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> RevisionWidgetEntry {
        RevisionWidgetEntry(date: .now, activities: [], streak: 0)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (RevisionWidgetEntry) -> Void) {
        completion(makeEntry())
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<RevisionWidgetEntry>) -> Void) {
        let calender = Calendar.current
        let startOfTommorow = calender.startOfDay(for: calender.date(byAdding: .day, value: 1, to: .now) ?? .now)
        
        let timeline = Timeline(entries: [makeEntry()], policy: .after(startOfTommorow))
        completion(timeline)
    }
    
    private func makeEntry() -> RevisionWidgetEntry {
        do {
            let context = ModelContext(SharedModelContainer.container)
            let sessions = try context.fetch(FetchDescriptor<RevisionSession>())
            
            let widgetActivities = ContributionGraphCalculator.dayActivities(from: sessions, numberOfDays: 70)
            let fullHistory = ContributionGraphCalculator.dayActivities(from: sessions)
            let streak = StreakCalculator.currentStreak(from: fullHistory)
            
            return RevisionWidgetEntry(date: .now, activities: widgetActivities, streak: streak)
        } catch {
            print("Widget failed to fetch sessions: \(error)")
            return RevisionWidgetEntry(date: .now, activities: [], streak: 0)
        }
    }
}
