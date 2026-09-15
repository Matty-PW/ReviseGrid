//
//  ContributionLevelColor.swift
//  ReviseGrid
//
//  Created by Matty on 15/09/2026.
//

import SwiftUI

enum ContributionLevelColor {
    static func color(forLevel level: Int?) -> Color {
        guard let level else { return .clear }
        
        switch level {
        case 0: return Color(uiColor: .tertiarySystemFill)
        case 1: return Color(light: "c6f0d2", dark: "14452a")
        case 2: return Color(light: "7ddc98", dark: "1e7a3f")
        case 3: return Color(light: "34b65b", dark: "2fb456")
        default: return Color(light: "1a7a3c", dark: "5fe586")
        }
    }
}
