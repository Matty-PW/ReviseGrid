//
//  OnboardingView.swift
//  RevisionWidgetExtension
//
//  Created by Matty on 15/09/2026.
//

import SwiftUI
import SwiftData

private enum OnboardingStep: Int {
    case welcome
    case name
    case subjects
}

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("userName") private var userName = ""
    
    @State private var step: OnboardingStep = .welcome
    @State private var nameInput: String = ""
    
    private let suggestedSubjects = ["Maths", "English", "Physics", "Biology", "Chemistry", "History", "Geography", "Further Maths", "Computer Science", "Engineering", "Business", "French", "RE"]
    @State private var selectedSuggestions: Set<String> = []
    @State private var customSubjects: [String] = []
    @State private var newSubjectName: String = ""
    
    var body: some View {
        VStack {
            switch step {
            case .welcome:
                welcomeStep
            case .name:
                nameStep
            case .subjects:
                subjectsStep
            }
        }
        .padding()
        .animation(.easeInOut, value: step)
        .onAppear {
            if selectedSuggestions.isEmpty {
                selectedSuggestions = Set(suggestedSubjects)
            }
        }
    }
    
    private var welcomeStep: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "square.grid.3x3.fill")
                .font(.system(size: 60))
                .foregroundStyle(.green)
            Text("Welcome to ReviseGrid")
                .font(.largeTitle.bold())
            Text("Log your revision, build a streak, and watch your contribution graph grow")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Spacer()
            Button("Get Started") {
                step = .name
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
    }
    
    private var nameStep: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("What should we call you?")
                .font(.title2.bold())
            TextField("Your name", text: $nameInput)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 40)
                .multilineTextAlignment(.center)
            Spacer()
            Button("Continue") {
                userName = nameInput.trimmingCharacters(in: .whitespaces)
                step = .subjects
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(nameInput.trimmingCharacters(in: .whitespaces).isEmpty)
        }
    }
    
    private var subjectsStep: some View {
        VStack(spacing: 16) {
            Text("Pick your subjects")
                .font(.title2.bold())
                .padding(.top)
            Text("Untick anything you don't need, and add your own below. You can always change this later.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            List {
                Section("Suggested") {
                    ForEach(suggestedSubjects, id: \.self) { subject in
                        Button {
                            toggleSuggestion(subject)
                        } label: {
                            HStack {
                                Text(subject)
                                    .foregroundStyle(.primary)
                                Spacer()
                                Image(systemName: selectedSuggestions.contains(subject) ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(selectedSuggestions.contains(subject) ? .green : .secondary)
                            }
                        }
                    }
                }
                
                if !customSubjects.isEmpty {
                    Section("Added by you") {
                        ForEach(customSubjects, id: \.self) { subject in
                            Text(subject)
                        }
                        .onDelete { indices in
                            customSubjects.remove(atOffsets: indices)
                        }
                    }
                }
                
                Section {
                    HStack {
                        TextField("Add a subject", text: $newSubjectName)
                        Button("Add") {
                            addCustomSubject()
                        }
                        .disabled(newSubjectName.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                }
            }
            .listStyle(.insetGrouped)
            
            Button("Get Started") {
                finishOnboarding()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.bottom)
        }
    }
    
    private func toggleSuggestion(_ subject: String) {
        if selectedSuggestions.contains(subject) {
            selectedSuggestions.remove(subject)
        } else {
            selectedSuggestions.insert(subject)
        }
    }
    
    private func addCustomSubject() {
        let trimmed = newSubjectName.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        customSubjects.append(trimmed)
        newSubjectName = ""
    }
    
    private func finishOnboarding() {
        var seenNames = Set<String>()
        var finalSubjects: [String] = []
        
        for name in Array(selectedSuggestions) + customSubjects {
            let key = name.lowercased()
            guard !seenNames.contains(key) else { continue }
            seenNames.insert(key)
            finalSubjects.append(name)
        }
        
        for name in finalSubjects {
            modelContext.insert(Subject(name: name))
        }
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save onboarding subjects: \(error)")
        }
        
        hasCompletedOnboarding = true
    }
}
