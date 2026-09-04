//
//  RevisionSession.swift
//  ReviseGrid
//
//  Created by Matty on 04/09/2026.
//

import Foundation
import SwiftData

@Model
final class RevisionSession {
    var id: UUID
    var date: Date
    var durationMinutes: Int
    var subject: Subject?
    
    init(date: Date, durationMinutes: Int, subject: Subject) {
        self.id = UUID()
        self.date = date
        self.durationMinutes = durationMinutes
        self.subject = subject
    }
}
