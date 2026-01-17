//
//  ShieldButtonConfigurationView.swift
//  MyBlockMyChoice
//
//  Created by Itsuki on 2026/01/17.
//

import SwiftUI
import ManagedSettings

struct ShieldButtonConfigurationView: View {
    @Binding var buttonConfiguration: ShieldButtonConfiguration

    var body: some View {
        ShieldLabelConfigurationView(label: $buttonConfiguration.label)
        Picker(
            "Action",
            selection: $buttonConfiguration.action,
            content: {
                ForEach(
                    ShieldActionResponse.choiceAvailable,
                    id: \.rawValue,
                    content: { actionResponse in
                        VStack(
                            alignment: .leading,
                            content: {
                                Text(actionResponse.descriptionTitle)
                                Text(actionResponse.descriptionSubtitle)
                                    .foregroundStyle(.secondary)
                                    .font(.subheadline)
                            }
                        )
                        .tag(actionResponse)
                    }
                )
            }
        )
    }
}
