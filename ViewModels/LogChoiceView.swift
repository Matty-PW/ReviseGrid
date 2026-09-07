//
//  LogChoiceView.swift
//  ReviseGrid
//
//  Created by Matty on 07/09/2026.
//

import SwiftUI

struct LogChoiceView: View {
    var viewModel: LogPanelViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Log Revision")
                .font(.headline)
                .padding(.top, 20)
            
            Button {
                viewModel.showTimer()
            } label: {
                Label("Start Timer", systemImage: "play.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            
            Button {
                viewModel.showManualForm()
            } label: {
                Label("Log Manually", systemImage: "pencil")
            }
            .buttonStyle(.bordered)
            
            Button("Cancel") {
                viewModel.dismiss()
            }
            .padding(.bottom, 12)
        }
        .padding(.horizontal)
    }
}
