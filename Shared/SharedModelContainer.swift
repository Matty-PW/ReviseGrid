//
//  SharedModelContainer.swift
//  ReviseGrid
//
//  Created by Matty on 04/09/2026.
//

import Foundation
import SwiftData

enum SharedModelContainer {
    static let appGroupID = "group.com.mattypw.revisegrid"
    
    static let container: ModelContainer = {
        let schema = Schema([
            Subject.self,
            RevisionSession.self
        ])
        
        guard let groupURL = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: appGroupID)
        else {
            fatalError("Could not find App Group container. Check that '\(appGroupID) matches the App Group you added in signing and capabilities.")
        }
        
        let storeURL = groupURL.appendingPathComponent("ReviseGrid.sqlite")
        let configuration = ModelConfiguration(schema: schema, url: storeURL)
        
        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
}
