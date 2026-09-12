//
//  RevisionWidgetEntry.swift
//  RevisionWidgetExtension
//
//  Created by Matty on 12/09/2026.
//

import WidgetKit

struct RevisionWidgetEntry: TimelineEntry {
    let date: Date
    let activities: [DayActivity]
    let streak: Int
}
