//
//  TimerLogView.swift
//  ReviseGrid
//
//  Created by Matty on 06/09/2026.
//

import SwiftUI
import SwiftData

struct TimerLogView: View {
    let onDismiss: () -> Void

    @Query(sort: \Subject.name) private var subjects: [Subject]
    @State private var selectedSubject: Subject?
    @State private var showingCancelConfirmation = false

    private var timer: TimerController { .shared }
    private var isActive: Bool { timer.state != nil }
    private var isPaused: Bool { timer.state?.pausedElapsed != nil }

    var body: some View {
        NavigationStack {
            VStack(spacing: 28) {
                SubjectPickerView(selectedSubject: $selectedSubject)
                    .disabled(isActive)
                    .padding(.horizontal)

                Group {
                    if let state = timer.state {
                        TimerReadoutView(state: state)
                    } else {
                        Text("0:00")
                    }
                }
                .font(.system(size: 56, weight: .bold, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(isActive && !isPaused ? .primary : .secondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal)

                if isActive {
                    HStack(spacing: 12) {
                        Button {
                            Task { await timer.togglePause() }
                        } label: {
                            Text(isPaused ? "Resume" : "Pause")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 4)
                        }
                        .buttonStyle(.bordered)

                        Button {
                            Task { await timer.stop() }
                            onDismiss()
                        } label: {
                            Text("Stop")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 4)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                    }
                    .controlSize(.large)
                    .padding(.horizontal)
                } else {
                    Button {
                        if let subject = selectedSubject {
                            timer.start(subjectName: subject.name)
                        }
                    } label: {
                        Text("Start")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 4)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                    .controlSize(.large)
                    .disabled(selectedSubject == nil)
                    .padding(.horizontal)
                }

                Spacer()
            }
            .padding(.top, 24)
            .navigationTitle("Timer")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        if isActive {
                            showingCancelConfirmation = true
                        } else {
                            onDismiss()
                        }
                    }
                }
            }
            .alert("Discard this session?", isPresented: $showingCancelConfirmation) {
                Button("Discard", role: .destructive) {
                    Task { await timer.discard() }
                    onDismiss()
                }
                Button("Keep Going", role: .cancel) { }
            } message: {
                Text("Your timer is still active. Cancelling now won't save this session.")
            }
        }
        .onAppear {
            if let name = timer.subjectName {
                selectedSubject = subjects.first { $0.name == name }
            }
        }
    }
}
