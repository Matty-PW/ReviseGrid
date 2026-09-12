//
//  RevisionWidgetView.swift
//  RevisionWidgetExtension
//
//  Created by Matty on 12/09/2026.
//

import SwiftUI
import WidgetKit

struct RevisionWidgetView: View {
    var entry: RevisionWidgetProvider.Entry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("\(entry.streak) day streak")
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
            
            RevisionWidgetGraphView(activities: entry.activities)
            
            Spacer(minLength: 0)
        }
        .padding(12)
    }
}
