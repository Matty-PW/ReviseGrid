//
//  TimerLogView.swift
//  ReviseGrid
//
//  Created by Matty on 06/09/2026.
//

import SwiftUI
import SwiftData

struct TimerLogView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedSubject: Subject?
    @State private var startDate: Date?
    @State private var showingCancelConfirmation = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                SubjectPickerView(selectedSubject: $selectedSubject)
                    .disabled(startDate != nil)
                    .padding(.horizontal)
                
                if let startDate {
                    Text(startDate, style: .timer)
                        .font(.system(size: 48, weight: .semibold, design: .rounded))
                        .foregroundStyle(.secondary)
                }
                
                Button(startDate == nil ? "Start" : "Stop") {
                    startDate == nil ? start() : stop()
                }
                .buttonStyle(.borderedProminent)
                .disabled(selectedSubject == nil)
                
                Spacer()
            }
            .padding(.top, 32)
            .navigationTitle("Timer")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        if startDate != nil {
                            showingCancelConfirmation = true
                        } else {
                            dismiss()
                        }
                    }
                }
            }
            .alert("Discard this session?", isPresented: $showingCancelConfirmation) {
                Button("Discard", role: .destructive) { dismiss() }
                Button("Keep Going", role: .cancel) { }
            } message: {
                Text("Your timer is still running. Cancelling now won't save this session.")
            }
        }
    }
    
    private func start() {
        startDate = .now
    }
    
    private func stop() {
        guard let startDate, let subject = selectedSubject else { return }
        let elapsedSeconds = Date.now.timeIntervalSince(startDate)
        let minutes = max(1, Int(elapsedSeconds / 60))
        
        let session = RevisionSession(date: startDate, durationMinutes: minutes, subject: subject)
        modelContext.insert(session)
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save session \(error)")
        }
        
        dismiss()
    }
}
