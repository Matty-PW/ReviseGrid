//
//  RevisionWidgetGraphView.swift
//  RevisionWidgetExtension
//
//  Created by Matty on 12/09/2026.
//

import SwiftUI

struct RevisionWidgetGraphView: View {
    let activities: [DayActivity]
    
    private let cellSize: CGFloat = 8
    private let cellSpacing: CGFloat = 2
    
    var body: some View {
        LazyHGrid(rows: Array(repeating: GridItem(.fixed(cellSize), spacing: cellSpacing), count: 7), spacing: cellSpacing
        ) {
            ForEach(Array(paddedCells.enumerated()), id: \.offset) { _, activity in RoundedRectangle(cornerRadius: 1.5)
                    .fill(color(forLevel: activity?.level))
                    .frame(width: cellSize, height: cellSize)
            }
        }
    }
    
    private var paddedCells: [DayActivity?] {
        guard let firstDay = activities.first?.date else { return [] }
        let weekday = Calendar.current.component(.weekday, from: firstDay)
        let leadingEmptyDays = weekday - 1
        return Array(repeating: nil, count: leadingEmptyDays) + activities
    }
    
    private func color(forLevel level: Int?) -> Color {
        switch level {
        case nil: return .clear
        case 0: return Color.gray.opacity(0.15)
        case 1: return Color.green.opacity(0.3)
        case 2: return Color.green.opacity(0.5)
        case 3: return Color.green.opacity(0.75)
        default: return .green

        }
    }
}
