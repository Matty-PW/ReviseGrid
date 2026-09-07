//
//  ManualLogFormView.swift
//  ReviseGrid
//
//  Created by Matty on 06/09/2026.
//

import SwiftUI
import SwiftData

struct ManualLogFormView: View {
    @Environment(\.modelContext) private var modelContext
    let onDismiss: () -> Void
    
    @State private var selectedSubject: Subject?
    @State private var durationMinutes: Int = 30
    @State private var date: Date = .now
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Subject") {
                    SubjectPickerView(selectedSubject: $selectedSubject)
                }
                
                Section("Duration") {
                    Stepper("\(durationMinutes) minutes", value: $durationMinutes, in: 5...600, step: 5)
                }
                
                Section("Date") {
                    DatePicker("Date", selection: $date, in: ...Date.now, displayedComponents: .date)
                        .labelsHidden()
                }
            }
            .navigationTitle("Log session")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { onDismiss() }
                        .disabled(selectedSubject == nil)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(selectedSubject == nil)
                }
            }
        }
    }
    
    private func save() {
        guard let subject = selectedSubject else { return }
        let session = RevisionSession(date: date, durationMinutes: durationMinutes, subject: subject)
        modelContext.insert(session)
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save session: \(error)")
        }
        
        onDismiss()
    }
}
