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
    @State private var isAddingSubject = false
    @FocusState private var isNewSubjectFieldFocused: Bool
        
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(subjects) { subject in
                        chip(for: subject)
                    }
                    addChip
                }
                .padding(.vertical, 2)
            }
            
            if isAddingSubject {
                HStack {
                    TextField("New subject name", text: $newSubjectName)
                        .textFieldStyle(.roundedBorder)
                        .focused($isNewSubjectFieldFocused)
                        .onSubmit { addSubject() }
                    Button("Add") { addSubject() }
                        .disabled(newSubjectName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isAddingSubject)
    }
    
    private func chip(for subject: Subject) -> some View {
        let isSelected = selectedSubject?.persistentModelID == subject.persistentModelID
        return Button {
            selectedSubject = subject
        } label: {
            Text(subject.name)
                .font(.subheadline.weight(isSelected ? .semibold : .regular))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Capsule().fill(isSelected ? Color.accentColor : Color.primary.opacity(0.08)))
        }
        .buttonStyle(.plain)
    }
    
    private var addChip: some View {
        Button {
            isAddingSubject = true
            isNewSubjectFieldFocused = true
        } label: {
            Label("New", systemImage: "plus")
                .font(.subheadline)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Capsule().strokeBorder(Color.accentColor, style: StrokeStyle(lineWidth: 1, dash: [4])))
                .foregroundStyle(Color.accentColor)
        }
        .buttonStyle(.plain)
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
        }
        newSubjectName = ""
        isAddingSubject = false
    }
}
