//
//  TimerLiveActivity.swift
//  RevisionWidgetExtension
//
//  Created by Matty on 02/10/2026.
//

import ActivityKit
import AppIntents
import WidgetKit
import SwiftUI

struct TimerLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimerActivityAttributes.self) { context in
            VStack(spacing: 12) {
                HStack(spacing: 16) {
                    Image(systemName: "timer")
                        .font(.title2)
                        .foregroundStyle(.green)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(context.attributes.subjectName)
                            .font(.headline)
                            .foregroundStyle(.white)
                        Text(context.state.pausedElapsed == nil ? "Revising" : "Paused")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.7))
                    }

                    Spacer()

                    TimerReadoutView(state: context.state)
                        .font(.system(.title2, design: .rounded, weight: .semibold))
                        .monospacedDigit()
                        .foregroundStyle(.white)
                }

                TimerActivityButtons(isPaused: context.state.pausedElapsed != nil)
            }
            .padding()
            .activityBackgroundTint(Color.black.opacity(0.85))
            .activitySystemActionForegroundColor(Color.white)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: "timer")
                        .foregroundStyle(.green)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    TimerReadoutView(state: context.state)
                        .monospacedDigit()
                }
                DynamicIslandExpandedRegion(.bottom) {
                    VStack(spacing: 10) {
                        Text(context.attributes.subjectName)
                            .font(.headline)
                        TimerActivityButtons(isPaused: context.state.pausedElapsed != nil)
                    }
                }
            } compactLeading: {
                Image(systemName: context.state.pausedElapsed == nil ? "timer" : "pause.fill")
                    .foregroundStyle(.green)
            } compactTrailing: {
                TimerReadoutView(state: context.state)
                    .monospacedDigit()
                    .frame(width: 44)
            } minimal: {
                Image(systemName: context.state.pausedElapsed == nil ? "timer" : "pause.fill")
                    .foregroundStyle(.green)
            }
        }
    }
}

private struct TimerActivityButtons: View {
    let isPaused: Bool

    var body: some View {
        HStack(spacing: 12) {
            Button(intent: ToggleTimerPauseIntent()) {
                Label(isPaused ? "Resume" : "Pause", systemImage: isPaused ? "play.fill" : "pause.fill")
                    .frame(maxWidth: .infinity)
            }
            .tint(.green)

            Button(intent: StopTimerIntent()) {
                Label("Stop", systemImage: "stop.fill")
                    .frame(maxWidth: .infinity)
            }
            .tint(.red)
        }
        .buttonStyle(.bordered)
    }
}
