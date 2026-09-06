//
//  Subject.swift
//  ReviseGrid
//
//  Created by Matty on 04/09/2026.
//

import Foundation
import SwiftData

@Model
final class Subject {
    var name: String
    var dateAdded: Date
    
    @Relationship(deleteRule: .cascade, inverse: \RevisionSession.subject)
    var sessions: [RevisionSession] = []
    
    init(name: String) {
        self.name = name
        self.dateAdded = .now
    }
}
