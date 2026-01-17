//
//  ShieldConfigurationView.swift
//  MyBlockMyChoice
//
//  Created by Itsuki on 2026/01/17.
//


import SwiftUI
import PhotosUI
import ManagedSettings

struct ShieldConfigurationView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var configuration: ShieldAppearanceConfiguration
    
    @State private var configurationTemp: ShieldAppearanceConfiguration = ShieldAppearanceConfiguration.defaultConfiguration
    @State private var pickerItem: PhotosPickerItem?
    @State private var enableSecondaryButton: Bool = false
    @State private var secondaryButtonConfiguration: ShieldButtonConfiguration = .init(label: .init(text: "", rgba: UIColor.blue.rgba), actionRawValue: ShieldActionResponse.none.rawValue)

    @State private var showPreviewView: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Picker(selection: $configurationTemp.backgroundBlurStyle, content: {
                        ForEach(UIBlurEffect.Style.choiceAvailable, id: \.?.rawValue) { style in
                            Text(style.title)
                                .tag(style)
                        }
                    }, label: {
                        Text("Background Blur Style")
                    })
                    
                    ColorPicker("Background Color", selection: $configurationTemp.backgroundColor)
                    
                
                    HStack {
                        Text("Icon")
                        Spacer()
                        if let image = configurationTemp.icon {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                        }

                        PhotosPicker(selection: $pickerItem, matching: .images, photoLibrary: .shared()) {
                            Text("Change Image")
                                
                        }
                        .buttonStyle(.borderless)

                    }
                }
                Section("Title") {
                    ShieldLabelConfigurationView( label: $configurationTemp.title)

                }
                Section("Subtitle") {
                    ShieldLabelConfigurationView( label: $configurationTemp.subtitle)
                }
            
                Section("Primary Button") {
                    ShieldButtonConfigurationView(buttonConfiguration: $configurationTemp.primaryButton)
                    ColorPicker("Background Color", selection: $configurationTemp.primaryButtonBackgroundColor)

                }
                
                Section("Secondary Button") {
                    Toggle("Enable", isOn: $enableSecondaryButton)
                    if enableSecondaryButton {
                        ShieldButtonConfigurationView(buttonConfiguration: $secondaryButtonConfiguration)
                    }
                }

            }
            .buttonStyle(.plain)
            .contentMargins(.top, 16)
            .navigationTitle("Configure Shield")
            .navigationBarTitleDisplayMode(.large)
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading, content: {
                    Button(action: {
                        self.dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                    })
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.circle)
                })
                .sharedBackgroundVisibility(.hidden)
                
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button(action: {
                        self.updateSecondaryButtonConfig()
                       showPreviewView = true
                    }, label: {
                        Text("Preview")
                    })
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                })
                .sharedBackgroundVisibility(.hidden)

                
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button(action: {
                        self.updateSecondaryButtonConfig()
                        configuration = configurationTemp
                        self.dismiss()
                    }, label: {
                        Image(systemName: "checkmark")
                    })
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.circle)
                })
                .sharedBackgroundVisibility(.hidden)
            })
            .onChange(of: configuration, initial: true, {
                self.configurationTemp = configuration
                if let secondaryButtonConfiguration = self.configurationTemp.secondaryButton {
                    self.secondaryButtonConfiguration = secondaryButtonConfiguration
                    self.enableSecondaryButton = true
                } else {
                    self.enableSecondaryButton = false
                }
            })
            .task(id: pickerItem,  {
                if let loaded = try? await pickerItem?.loadTransferable(type: TransferableImage.self) {
                    self.configurationTemp.icon = loaded.uiImage
                }
            })
            .sheet(isPresented: $showPreviewView, content: {
                ShieldConfigurationPreviewView(configuration: $configurationTemp)
            })

        }

    }
    
    private func updateSecondaryButtonConfig() {
        configurationTemp.secondaryButton = enableSecondaryButton ? secondaryButtonConfiguration : nil
    }
}
  
struct ShieldLabelConfigurationView: View {
    @Binding var label: ShieldLabelConfiguration
    
    var body: some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 8, content: {
                Text("Text")

                Text("Use \(ShieldLabelConfiguration.appNamePlaceholder) placeholder for app name.")
                    .foregroundStyle(.secondary)
                    .font(.caption)
                    .lineLimit(2)
                    .minimumScaleFactor(0.6)
            })
            .frame(maxWidth: 144)
            Spacer()
            TextField(text: $label.text, prompt: Text("Enter some text..."), axis: .vertical, label: { })
                .multilineTextAlignment(.trailing)
                .foregroundStyle(.secondary)

        }
        ColorPicker("Color", selection: $label.color)
    }
}

struct ShieldButtonConfigurationView: View {
    @Binding var buttonConfiguration: ShieldButtonConfiguration

    var body: some View {
        ShieldLabelConfigurationView(label: $buttonConfiguration.label)
        Picker("Action", selection: $buttonConfiguration.action, content: {
            ForEach(ShieldActionResponse.choiceAvailable,id: \.rawValue, content: { actionResponse in
                VStack(alignment: .leading, content: {
                    Text(actionResponse.descriptionTitle)
                    Text(actionResponse.descriptionSubtitle)
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                })
                .tag(actionResponse)
            })
        })
    }
}

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
                            .foregroundColor(configuration.primaryButton.label.color)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                            .background(configuration.primaryButtonBackgroundColor)
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
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button(action: {
                        self.dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                    })
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.circle)
                })
                .sharedBackgroundVisibility(.hidden)
            })
        }
    }
}


#Preview {
    ShieldConfigurationView(configuration: .constant(.defaultConfiguration))
}
    

