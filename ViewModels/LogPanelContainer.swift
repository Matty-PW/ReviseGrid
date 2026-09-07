//
//  LogPanelContainer.swift
//  ReviseGrid
//
//  Created by Matty on 07/09/2026.
//

import SwiftUI

struct LogPanelContainer: View {
    var viewModel: LogPanelViewModel
    
    var body: some View {
        ZStack(alignment: .top) {
            if viewModel.isVisible {
                Color.black.opacity(0.35)
                    .ignoresSafeArea()
                    .onTapGesture { viewModel.dismiss() }
                    .transition(.opacity)
                
                panelContent
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20))
                    .padding(.horizontal)
                    .padding(.top, 12)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.85), value: viewModel.mode)
    }
    
    @ViewBuilder
    private var panelContent: some View {
        switch viewModel.mode {
        case .hidden:
            EmptyView()
        case .choice:
            LogChoiceView(viewModel: viewModel)
        case .manual:
            ManualLogFormView(onDismiss: { viewModel.dismiss() })
        case .timer:
            TimerLogView(onDismiss: { viewModel.dismiss() })
        }
    }
}
