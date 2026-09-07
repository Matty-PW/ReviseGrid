//
//  RootView.swift
//  ReviseGrid
//
//  Created by Matty on 07/09/2026.
//

import SwiftUI

struct RootView: View {
    @State private var panelViewModel = LogPanelViewModel()
    
    var body: some View {
        ZStack {
            ContentView(panelViewModel: panelViewModel)
            LogPanelContainer(viewModel: panelViewModel)
        }
    }
}
