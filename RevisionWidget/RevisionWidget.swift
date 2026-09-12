//
//  RevisionWidget.swift
//  RevisionWidget
//
//  Created by Matty on 12/09/2026.
//

import WidgetKit
import SwiftUI

struct RevisionWidget: Widget {
    let kind: String = "RevisionWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: RevisionWidgetProvider()) { entry in
            RevisionWidgetView(entry: entry)
                .containerBackground(.background, for: .widget)
        }
        .configurationDisplayName("Revision Streak")
        .description("See your revision streak at a glance.")
        .supportedFamilies([.systemSmall])
    }
}
