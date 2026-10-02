//
//  TimerActivityAttributes.swift
//  ReviseGrid
//
//  Created by Matty on 02/10/2026.
//

import Foundation
import ActivityKit

struct TimerActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var startDate: Date
    }
    
    var subjectName: String
}
