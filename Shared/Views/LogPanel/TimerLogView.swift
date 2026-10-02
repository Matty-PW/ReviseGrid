//
//  TimerLogView.swift
//  ReviseGrid
//
//  Created by Matty on 06/09/2026.
//

import SwiftUI
import SwiftData
import WidgetKit
import ActivityKit

struct TimerLogView: View {
    @Environment(\.modelContext) private var modelContext
    let onDismiss: () -> Void
    
    @Query(sort: \Subject.name) private var subjects: [Subject]
    
    @State private var selectedSubject: Subject?
    @State private var startDate: Date?
    @State private var showingCancelConfirmation = false
    @State private var currentActivity: Activity<TimerActivityAttributes>?
    
    private var isRunning: Bool { startDate != nil }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 28) {
                SubjectPickerView(selectedSubject: $selectedSubject)
                    .disabled(isRunning)
                    .padding(.horizontal)
                
                Group {
                if let startDate {
                    Text(startDate, style: .timer)
                } else {
                    Text("00:00")
                }
            }
            .font(.system(size: 56, weight: .bold, design: .rounded))
            .monospacedDigit()
            .foregroundStyle(isRunning ? .primary : .secondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal)
            
                Button {
                    isRunning ? stop() : start()
                } label: {
                    Text(isRunning ? "Stop" : "Start")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 4)
                }
                .buttonStyle(.borderedProminent)
                .disabled(selectedSubject == nil)
                .tint(isRunning ? .red : .green)
                .controlSize(.large)
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top, 24)
            .navigationTitle("Timer")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        if isRunning {
                            showingCancelConfirmation = true
                        } else {
                            onDismiss()
                        }
                    }
                }
            }
            .alert("Discard this session?", isPresented: $showingCancelConfirmation) {
                Button("Discard", role: .destructive) { onDismiss() }
                Button("Keep Going", role: .cancel) { }
            } message: {
                Text("Your timer is still running. Cancelling now won't save this session.")
            }
        }
        .task {
            reattachToRunningActivityIfNeeded()
        }
    }
    
    private func reattachToRunningActivityIfNeeded() {
        guard currentActivity == nil, let existing = Activity<TimerActivityAttributes>.activities.first else { return }
        currentActivity = existing
        startDate = existing.content.state.startDate
        selectedSubject = subjects.first { $0.name == existing.attributes.subjectName }
    }
    
    private func start() {
        guard let subject = selectedSubject else { return }
        let now = Date.now
        startDate = now
        
        let attributes = TimerActivityAttributes(subjectName: subject.name)
        let state = TimerActivityAttributes.ContentState(startDate: now)
        
        do {
            currentActivity = try Activity.request(attributes: attributes, content: .init(state: state, staleDate: nil)
            )
        } catch {
            print("Failed to start live activity \(error)")
        }
    }
    
    private func stop() {
        guard let startDate, let subject = selectedSubject else { return }
        let elapsedSeconds = Date.now.timeIntervalSince(startDate)
        let minutes = max(1, Int(elapsedSeconds / 60))
        
        let session = RevisionSession(date: startDate, durationMinutes: minutes, subject: subject)
        modelContext.insert(session)
        
        do {
            try modelContext.save()
            WidgetCenter.shared.reloadAllTimelines()
        } catch {
            print("Failed to save session \(error)")
        }
        
        onDismiss()
    }
}
