//
//  RootView.swift
//  ReviseGrid
//
//  Created by Matty on 07/09/2026.
//

import SwiftUI

struct RootView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var panelViewModel = LogPanelViewModel()
    
    var body: some View {
        ZStack {
            if hasCompletedOnboarding {
                TabView {
                    ContentView(panelViewModel: panelViewModel)
                        .tabItem {
                            Label("Home", systemImage: "square.grid.3x3.fill")
                        }
                    
                    SubjectTotalsView()
                        .tabItem {
                            Label("Totals", systemImage: "chart.bar.fill")
                        }
                    
                    SettingsView()
                        .tabItem {
                            Label("Settings", systemImage: "gearshape.fill")
                        }
                }
                
                LogPanelContainer(viewModel: panelViewModel)
            } else {
                OnboardingView()
            }
        }
    }
}
