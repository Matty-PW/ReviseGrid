//
//  ContributionLevelColor.swift
//  RevisionWidgetExtension
//
//  Created by Matty on 15/09/2026.
//

import SwiftUI

enum ContributionLevelColor {
    static func color(forLevel level: Int?) -> Color {
        guard let level else { return .clear }
        
        switch level {
        case 0: return Color(light: "ebedf0", dark: "161b22")
        case 1: return Color(light: "9be9a8", dark: "0e4429")
        case 2: return Color(light: "40c463", dark: "006d32")
        case 3: return Color(light: "30a14e", dark: "26a641")
        default: return Color(light: "216e39", dark: "39d353")
        }
    }
}
