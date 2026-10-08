//
//  TimerReadoutView.swift
//  ReviseGrid
//
//  Created by Matty on 08/10/2026.
//

import SwiftUI

struct TimerReadoutView: View {
    let state: TimerActivityAttributes.ContentState
    
    var body: some View {
        if let elapsed = state.pausedElapsed {
            Text(Duration.seconds(elapsed).formatted(.time(pattern: elapsed >= 3600 ? .hourMinuteSecond : .minuteSecond)))
        } else {
            Text(state.startDate, style: .timer)
        }
    }
}

