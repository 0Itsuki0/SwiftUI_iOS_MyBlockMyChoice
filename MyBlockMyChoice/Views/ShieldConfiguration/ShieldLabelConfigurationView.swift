//
//  ShieldLabelConfigurationView.swift
//  MyBlockMyChoice
//
//  Created by Itsuki on 2026/01/17.
//

import SwiftUI

struct ShieldLabelConfigurationView: View {
    @Binding var label: ShieldLabelConfiguration

    var body: some View {
        HStack(spacing: 8) {
            VStack(
                alignment: .leading,
                spacing: 8,
                content: {
                    Text("Text")

                    Text(
                        "Use \(ShieldLabelConfiguration.appNamePlaceholder) placeholder for app name."
                    )
                    .foregroundStyle(.secondary)
                    .font(.caption)
                    .lineLimit(2)
                    .minimumScaleFactor(0.6)
                }
            )
            .frame(maxWidth: 144)
            Spacer()
            TextField(
                text: $label.text,
                prompt: Text("Enter some text..."),
                axis: .vertical,
                label: {}
            )
            .multilineTextAlignment(.trailing)
            .foregroundStyle(.secondary)

        }
        ColorPicker("Color", selection: $label.color)
    }
}

