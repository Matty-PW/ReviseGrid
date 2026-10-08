//
//  TimerIntents.swift
//  ReviseGrid
//
//  Created by Matty on 08/10/2026.
//

import AppIntents

struct ToggleTimerPauseIntent: LiveActivityIntent {
    static let title: LocalizedStringResource = "Pause or Resume Timer"
    
    func perform() async throws -> some IntentResult {
        await TimerController.shared.togglePause()
        return . result()
    }
}

struct StopTimerIntent: LiveActivityIntent {
    static let title: LocalizedStringResource = "Stop Timer"
    
    func perform() async throws -> some IntentResult {
        await TimerController.shared.stop()
        return .result()
    }
}
