//
//  TimerController.swift
//  ReviseGrid
//
//  Created by Matty on 05/10/2026.
//

import Foundation
import ActivityKit
import Observation
import SwiftData
import WidgetKit

@MainActor
@Observable
final class TimerController {
    static let shared = TimerController()
    
    private(set) var subjectName: String?
    private(set) var sessionStart: Date?
    private(set) var state: TimerActivityAttributes.ContentState?
    
    @ObservationIgnored
    private var activity: Activity<TimerActivityAttributes>?
    
    private init() {
        guard let existing = Activity<TimerActivityAttributes>.activities.first(where: { $0.activityState == .active }) else { return }
        activity = existing
        subjectName = existing.attributes.subjectName
        sessionStart = existing.attributes.sessionStart
        state = existing.content.state
    }
    
    func start(subjectName: String) {
        guard state == nil else { return }
        let now = Date.now
        let newState = TimerActivityAttributes.ContentState(startDate: now, pausedElapsed: nil)
        
        self.subjectName = subjectName
        sessionStart = now
        state = newState
        
        do {
            activity = try Activity.request(attributes: TimerActivityAttributes(subjectName: subjectName, sessionStart: now), content: .init(state: newState, staleDate: nil)
            )
        } catch {
            print("Failed to start live activity \(error)")
        }
    }
    
    func togglePause() async {
        guard var newState = state else { return }
        let now = Date.now
        
        if let elapsed = newState.pausedElapsed {
            newState.startDate = now.addingTimeInterval(-elapsed)
            newState.pausedElapsed = nil
        } else {
            newState.pausedElapsed = now.timeIntervalSince(newState.startDate)
        }
        
        state = newState
        await activity?.update(.init(state: newState, staleDate: nil))
    }
    
    func stop() async {
        guard let state, let subjectName, let sessionStart else { return }
        let elapsed = state.pausedElapsed ?? Date.now.timeIntervalSince(state.startDate)
        let minutes = max(1, Int(elapsed / 60))
        
        let context = SharedModelContainer.container.mainContext
        let descriptor = FetchDescriptor<Subject>(predicate: #Predicate { $0.name == subjectName })
        
        do {
            let subject: Subject
            if let existing = try context.fetch(descriptor).first {
                subject = existing
            } else {
                subject = Subject(name: subjectName)
                context.insert(subject)
            }
            context.insert(RevisionSession(date: sessionStart, durationMinutes: minutes, subject: subject))
            try context.save()
            WidgetCenter.shared.reloadAllTimelines()
        } catch {
            print("failed to save session \(error)")
        }
        
        await clear()
    }
    
    func discard() async {
        await clear()
    }
    
    private func clear() async {
        let ending = activity
        activity = nil
        state = nil
        subjectName = nil
        sessionStart = nil
        await ending?.end(nil, dismissalPolicy: .immediate)
    }
}
