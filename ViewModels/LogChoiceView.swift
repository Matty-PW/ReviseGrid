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
        VStack(spacing: 20) {
            HStack {
                Text("Log Revision")
                    .font(.title3.bold())
                Spacer()
                Button {
                    viewModel.dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                }
                .accessibilityLabel("Close")
            }
            .padding(.top, 20)

            VStack(spacing: 12) {
                choiceCard(
                    icon: "play.fill",
                    title: "Start Timer",
                    subtitle: "Time yourself live",
                    tint: .green
                ) {
                    viewModel.showTimer()
                }

                choiceCard(
                    icon: "pencil",
                    title: "Log Manually",
                    subtitle: "Add a past session",
                    tint: .blue
                ) {
                    viewModel.showManualForm()
                }
            }
            .padding(.bottom, 20)
        }
        .padding(.horizontal)
    }

    private func choiceCard(icon: String, title: String, subtitle: String, tint: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(tint, in: RoundedRectangle(cornerRadius: 12))

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
            .padding(14)
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }
}

