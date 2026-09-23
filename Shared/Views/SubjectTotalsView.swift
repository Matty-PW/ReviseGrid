//
//  SubjectTotalsView.swift
//  RevisionWidgetExtension
//
//  Created by Matty on 14/09/2026.
//

import SwiftUI
import SwiftData

private enum TotalsRange: String, CaseIterable, Identifiable {
    case day = "Day"
    case week = "Week"
    case month = "Month"
    case allTime = "All Time"
    var id: String { rawValue }
}

struct SubjectTotalsView: View {
    @Query(sort: \Subject.name) private var subjects: [Subject]
    @State private var range: TotalsRange = .allTime
    
    private var sortedSubjects: [(subject: Subject, totalMinutes: Int)] {
        let calender = Calendar.current
        let now = Date()
        
        return subjects.map { subject in
            let relevantSessions = subject.sessions.filter { session in
                switch range {
                case .day:
                    return calender.isDate(session.date, inSameDayAs: now)
                case .week:
                    return calender.isDate(session.date, equalTo: now, toGranularity: .weekOfYear)
                case .month:
                    return calender.isDate(session.date, equalTo: now, toGranularity: .month)
                case .allTime:
                    return true
                }
            }
            let total = relevantSessions.reduce(0) { $0 + $1.durationMinutes }
            return (subject, total)
        }.sorted{ $0.totalMinutes > $1.totalMinutes }
    }
    
    var body: some View {
        NavigationStack {
            List {
                Picker("Range", selection: $range) {
                    ForEach(TotalsRange.allCases) { r in
                        Text(r.rawValue).tag(r)
                    }
                }
                .pickerStyle(.segmented)
                .listRowSeparator(.hidden)
                
                if sortedSubjects.isEmpty {
                    ContentUnavailableView("No Subjects Yet", systemImage: "book.closed", description: Text("Log a revision session to see your totals here"))
                } else {
                    ForEach(sortedSubjects, id: \.subject.persistentModelID) { item in
                        HStack {
                            Text(item.subject.name)
                            Spacer()
                            Text(formattedDuration(item.totalMinutes))
                                .foregroundStyle(item.totalMinutes > 0 ? .secondary : .tertiary)
                        }
                    }
                }
            }
            .navigationTitle("Totals")
        }
    }
    
    private func formattedDuration(_ minutes: Int) -> String {
        let hours = minutes / 60
        let remainingMinutes = minutes % 60
        return hours > 0 ? "\(hours)h \(remainingMinutes)m" : "\(remainingMinutes)m"
    }
}
