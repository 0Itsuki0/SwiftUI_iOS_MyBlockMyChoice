//
//  ShieldConfigurationPreviewView.swift
//  MyBlockMyChoice
//
//  Created by Itsuki on 2026/01/17.
//

import SwiftUI

struct ShieldConfigurationPreviewView: View {
    @Binding var configuration: ShieldAppearanceConfiguration

    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {

                Spacer()

                // Ban icon
                if let icon = configuration.icon {
                    Image(uiImage: icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64, height: 64)
                }

                Text(configuration.title.text)
                    .foregroundStyle(configuration.title.color)
                    .font(.system(size: 24, weight: .bold))

                Text(configuration.subtitle.text)
                    .foregroundStyle(configuration.subtitle.color)
                    .font(.system(size: 20))
                    .multilineTextAlignment(.center)
                    .lineSpacing(16)

                Spacer()

                VStack(spacing: 12) {
                    Button(action: {}) {
                        Text(configuration.primaryButton.label.text)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(
                                configuration.primaryButton.label.color
                            )
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                            .background(
                                configuration.primaryButtonBackgroundColor
                            )
                    }
                    .buttonSizing(.flexible)
                    .buttonBorderShape(.capsule)
                    .clipShape(.capsule)

                    if let secondaryButton = configuration.secondaryButton {
                        Button(action: {}) {
                            Text(secondaryButton.label.text)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(secondaryButton.label.color)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                .background(.white)
                        }
                        .buttonSizing(.flexible)
                        .buttonBorderShape(.capsule)
                        .clipShape(.capsule)
                    }
                }
            }
            .padding(.all, 24)
            .background(.yellow.opacity(0.02))
            .toolbar(content: {
                ToolbarItem(
                    placement: .topBarTrailing,
                    content: {
                        Button(
                            action: {
                                self.dismiss()
                            },
                            label: {
                                Image(systemName: "xmark")
                            }
                        )
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.circle)
                    }
                )
                .sharedBackgroundVisibility(.hidden)
            })
        }
    }
}
