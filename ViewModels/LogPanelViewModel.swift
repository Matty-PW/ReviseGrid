//
//  LogPanelViewModel.swift
//  ReviseGrid
//
//  Created by Matty on 07/09/2026.
//

import SwiftUI

@Observable
final class LogPanelViewModel {
    enum Mode {
        case hidden
        case choice
        case manual
        case timer
    }
    
    var mode: Mode = .hidden
    
    var isVisible: Bool {
        mode != .hidden
    }
    
    func present() {
        mode = .choice
    }
    
    func dismiss() {
        mode = .hidden
    }
    
    func showManualForm() {
        mode = .manual
    }
    
    func showTimer() {
        mode = .timer
    }
}
