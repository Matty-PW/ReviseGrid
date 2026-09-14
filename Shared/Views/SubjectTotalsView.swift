//
//  SubjectTotalsView.swift
//  RevisionWidgetExtension
//
//  Created by Matty on 14/09/2026.
//

import SwiftUI
import SwiftData

struct SubjectTotalsView: View {
    @Query(sort: \Subject.name) private var subjects: [Subject]
    
    private var sortedSubjects: [(subject: Subject, totalMinutes: Int)] { subjects
        .map { subject in let total = subject.sessions.reduce(0) { $0 + $1.durationMinutes }
            return (subject, total)
        }
        .sorted{ $0.totalMinutes > $1.totalMinutes }
        
    }
    
    var body: some View {
        NavigationStack {
            List {
                if sortedSubjects.isEmpty {
                    ContentUnavailableView("No Subjects Yet",
                                           systemImage: "book.closed",
                    description: Text("Log a revision session to see your totals here")
                    )
                } else {
                    ForEach(sortedSubjects, id: \.subject.persistentModelID) { item in
                        HStack {
                            Text(item.subject.name)
                            Spacer()
                            Text(formattedDuration(item.totalMinutes))
                                .foregroundStyle(.secondary)
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
