//
//  ShieldConfigurationView.swift
//  MyBlockMyChoice
//
//  Created by Itsuki on 2026/01/17.
//

import ManagedSettings
import PhotosUI
import SwiftUI

struct ShieldConfigurationView: View {
    @Environment(\.dismiss) private var dismiss

    @Binding var configuration: ShieldAppearanceConfiguration

    @State private var configurationTemp: ShieldAppearanceConfiguration =
        ShieldAppearanceConfiguration.defaultConfiguration
    @State private var pickerItem: PhotosPickerItem?
    @State private var enableSecondaryButton: Bool = false
    @State private var secondaryButtonConfiguration: ShieldButtonConfiguration =
        .init(
            label: .init(text: "", rgba: UIColor.blue.rgba),
            actionRawValue: ShieldActionResponse.none.rawValue
        )

    @State private var showPreviewView: Bool = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Picker(
                        selection: $configurationTemp.backgroundBlurStyle,
                        content: {
                            ForEach(
                                UIBlurEffect.Style.choiceAvailable,
                                id: \.?.rawValue
                            ) { style in
                                Text(style.title)
                                    .tag(style)
                            }
                        },
                        label: {
                            Text("Background Blur Style")
                        }
                    )

                    ColorPicker(
                        "Background Color",
                        selection: $configurationTemp.backgroundColor
                    )

                    HStack {
                        Text("Icon")
                        Spacer()
                        if let image = configurationTemp.icon {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                        }

                        PhotosPicker(
                            selection: $pickerItem,
                            matching: .images,
                            photoLibrary: .shared()
                        ) {
                            Text("Change Image")

                        }
                        .buttonStyle(.borderless)

                    }
                }
                Section("Title") {
                    ShieldLabelConfigurationView(
                        label: $configurationTemp.title
                    )

                }
                Section("Subtitle") {
                    ShieldLabelConfigurationView(
                        label: $configurationTemp.subtitle
                    )
                }

                Section("Primary Button") {
                    ShieldButtonConfigurationView(
                        buttonConfiguration: $configurationTemp.primaryButton
                    )
                    ColorPicker(
                        "Background Color",
                        selection: $configurationTemp
                            .primaryButtonBackgroundColor
                    )

                }

                Section("Secondary Button") {
                    Toggle("Enable", isOn: $enableSecondaryButton)
                    if enableSecondaryButton {
                        ShieldButtonConfigurationView(
                            buttonConfiguration: $secondaryButtonConfiguration
                        )
                    }
                }

            }
            .buttonStyle(.plain)
            .contentMargins(.top, 16)
            .navigationTitle("Configure Shield")
            .navigationBarTitleDisplayMode(.large)
            .toolbar(content: {
                ToolbarItem(
                    placement: .topBarLeading,
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

                ToolbarItem(
                    placement: .topBarTrailing,
                    content: {
                        Button(
                            action: {
                                self.updateSecondaryButtonConfig()
                                showPreviewView = true
                            },
                            label: {
                                Text("Preview")
                            }
                        )
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                    }
                )
                .sharedBackgroundVisibility(.hidden)

                ToolbarItem(
                    placement: .topBarTrailing,
                    content: {
                        Button(
                            action: {
                                self.updateSecondaryButtonConfig()
                                configuration = configurationTemp
                                self.dismiss()
                            },
                            label: {
                                Image(systemName: "checkmark")
                            }
                        )
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.circle)
                    }
                )
                .sharedBackgroundVisibility(.hidden)
            })
            .onChange(
                of: configuration,
                initial: true,
                {
                    self.configurationTemp = configuration
                    if let secondaryButtonConfiguration = self.configurationTemp
                        .secondaryButton
                    {
                        self.secondaryButtonConfiguration =
                            secondaryButtonConfiguration
                        self.enableSecondaryButton = true
                    } else {
                        self.enableSecondaryButton = false
                    }
                }
            )
            .task(
                id: pickerItem,
                {
                    if let loaded = try? await pickerItem?.loadTransferable(
                        type: TransferableImage.self
                    ) {
                        self.configurationTemp.icon = loaded.uiImage
                    }
                }
            )
            .sheet(
                isPresented: $showPreviewView,
                content: {
                    ShieldConfigurationPreviewView(
                        configuration: $configurationTemp
                    )
                }
            )

        }

    }

    private func updateSecondaryButtonConfig() {
        configurationTemp.secondaryButton =
            enableSecondaryButton ? secondaryButtonConfiguration : nil
    }
}
