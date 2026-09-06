//
//  ContentView.swift
//  ReviseGrid
//
//  Created by Matty on 03/09/2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \RevisionSession.date, order: .reverse) private var sessions: [RevisionSession]
    
    @State private var showingLogForm = false
    
    var body: some View {
        NavigationStack {
            List {
                ContributionGraphView(activities: ContributionGraphCalculator.dayActivities(from: sessions))
                    .padding(.horizontal)
                Text("Current streak: \(StreakCalculator.currentStreak(from: ContributionGraphCalculator.dayActivities(from: sessions))) days")
                    .padding(.horizontal)
                ForEach(sessions) { session in
                    VStack(alignment: .leading) {
                        Text(session.subject?.name ?? "Unknown subject")
                            .font(.headline)
                        Text("\(session.durationMinutes) min - \(session.date.formatted(date: .abbreviated, time: .shortened))")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                    }
                }
            }
            .navigationTitle("ReviseGrid (test)")
            .toolbar {
                Button("Log session") {
                    showingLogForm = true
                }
                .sheet(isPresented: $showingLogForm) {
                    TimerLogView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
