//
//  SubjectPickerView.swift
//  ReviseGrid
//
//  Created by Matty on 06/09/2026.
//

import SwiftUI
import SwiftData

struct SubjectPickerView: View {
    @Binding var selectedSubject: Subject?
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Subject.name) private var subjects: [Subject]
    
    @State private var newSubjectName: String = ""
    
    private var selectedSubjectIDBinding: Binding<PersistentIdentifier?> {
        Binding(
            get: { selectedSubject?.persistentModelID },
            set: { newID in selectedSubject = subjects.first { $0.persistentModelID == newID }
            }
        )
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if !subjects.isEmpty {
                Picker("Subject", selection: selectedSubjectIDBinding) {
                    Text("Select a subject").tag(PersistentIdentifier?.none)
                    ForEach(subjects) { subject in
                        Text(subject.name).tag(Optional(subject.persistentModelID))
                    }
                }
                .pickerStyle(.menu)
            }
            
            HStack {
                TextField("New subject name", text: $newSubjectName)
                    .textFieldStyle(.roundedBorder)
                Button("Add") {
                    addSubject()
                }
                .disabled(newSubjectName.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
    }
    
    private func addSubject() {
        let trimmedName = newSubjectName.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty else { return }
        
        if let existing = subjects.first(where: { $0.name.caseInsensitiveCompare(trimmedName) == .orderedSame}) {
            selectedSubject = existing
        } else {
            let subject = Subject(name: trimmedName)
            modelContext.insert(subject)
            selectedSubject = subject
            newSubjectName = ""
        }
        
    }
}
