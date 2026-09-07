//
//  ReviseGridApp.swift
//  ReviseGrid
//
//  Created by Matty on 03/09/2026.
//

import SwiftUI
import SwiftData

@main
struct ReviseGridApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(SharedModelContainer.container)
    }
}
