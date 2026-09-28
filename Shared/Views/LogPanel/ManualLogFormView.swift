//
//  ManualLogFormView.swift
//  ReviseGrid
//
//  Created by Matty on 06/09/2026.
//

import SwiftUI
import SwiftData
import WidgetKit

struct ManualLogFormView: View {
    @Environment(\.modelContext) private var modelContext
    let onDismiss: () -> Void
    
    @State private var selectedSubject: Subject?
    @State private var durationMinutes: Int = 30
    @State private var date: Date = .now
    
    private let durationPresets = [15, 30, 45, 60, 90]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Subject") {
                    SubjectPickerView(selectedSubject: $selectedSubject)
                }
                
                Section("Duration") {
                    HStack(spacing: 8) {
                        ForEach(durationPresets, id: \.self) { preset in
                            durationChip(preset)
                        }
                    }
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
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(selectedSubject == nil)
                }
            }
        }
    }
    
    private func durationChip(_ preset: Int) -> some View {
        let isSelected = durationMinutes == preset
        return Button {
            durationMinutes = preset
        } label: {
            Text("\(preset)m")
                .font(.subheadline.weight(isSelected ? .semibold : .regular))
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(Capsule().fill(isSelected ? Color.accentColor : Color.primary.opacity(0.08)))
                .foregroundStyle(isSelected ? .white : .primary)
        }
        .buttonStyle(.plain)
    }
    
    private func save() {
        guard let subject = selectedSubject else { return }
        let session = RevisionSession(date: date, durationMinutes: durationMinutes, subject: subject)
        modelContext.insert(session)
        
        do {
            try modelContext.save()
            WidgetCenter.shared.reloadAllTimelines()
        } catch {
            print("Failed to save session: \(error)")
        }
        
        onDismiss()
    }
}
