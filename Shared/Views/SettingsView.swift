//
//  SettingsView.swift
//  ReviseGrid
//
//  Created by Matty on 19/09/2026.
//

import SwiftUI
import SwiftData
import WidgetKit

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("userName") private var userName = ""
    @Query(sort: \Subject.name) private var subjects: [Subject]
    
    @State private var newSubjectName = ""
    @State private var renamingSubject: Subject?
    @State private var renameText = ""
    @State private var pendingDeleteOffsets: IndexSet?
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Profile") {
                    TextField("Your name", text: $userName)
                }
                
                Section("Subjects") {
                    ForEach(subjects) { subject in
                        Button {
                            renamingSubject = subject
                            renameText = subject.name
                        } label: {
                            HStack {
                                Text(subject.name)
                                    .foregroundStyle(.primary)
                                Spacer()
                                Text("\(subject.sessions.count) session\(subject.sessions.count == 1 ? "" : "s")")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .onDelete { offsets in
                            pendingDeleteOffsets = offsets
                    }
                    
                    HStack {
                        TextField("Add a subject", text: $newSubjectName)
                        Button("Add") {
                            addSubject()
                        }
                        .disabled(newSubjectName.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                }
            }
            .navigationTitle("Settings")
            .alert("Rename Subject", isPresented: renamingSubjectBinding) {
                TextField("Subject name", text: $renameText)
                Button("Cancel", role: .cancel) { renamingSubject = nil }
                Button("Save") { saveRename() }
            }
            .confirmationDialog(
                "Delete this subject?",
                isPresented: pendingDeleteBinding,
                titleVisibility: .visible
            ) {
                Button("Delete", role: .destructive) { performPendingDelete() }
                Button("Cancel", role: .cancel) { pendingDeleteOffsets = nil}
            } message: {
                Text("This will also delete every logged session for this subject. This can't be undone.")
            }
        }
    }
    
    private var renamingSubjectBinding: Binding<Bool> {
        Binding(
            get: { renamingSubject != nil },
            set: { if !$0 { renamingSubject = nil } }
        )
    }
    
    private var pendingDeleteBinding: Binding<Bool> {
        Binding(
            get: { pendingDeleteOffsets != nil },
            set: { if !$0 { pendingDeleteOffsets = nil } }
        )
    }
    
    private func addSubject() {
        let trimmed = newSubjectName.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        guard !subjects.contains(where: { $0.name.caseInsensitiveCompare(trimmed) == .orderedSame}) else {
            newSubjectName = ""
            return
        }
        modelContext.insert(Subject(name: trimmed))
        try? modelContext.save()
        newSubjectName = ""
    }
    
    private func saveRename() {
        guard let subject = renamingSubject else { return }
        let trimmed = renameText.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { renamingSubject = nil; return }
        subject.name = trimmed
        try? modelContext.save()
        renamingSubject = nil
    }
    
    private func performPendingDelete() {
        guard let offsets = pendingDeleteOffsets else { return }
        for index in offsets {
            modelContext.delete(subjects[index])
        }
        try? modelContext.save()
        WidgetCenter.shared.reloadAllTimelines()
        pendingDeleteOffsets = nil
    }
}
