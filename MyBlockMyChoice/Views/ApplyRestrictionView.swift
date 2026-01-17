//
//  ApplyRestrictionView.swift
//  MyBlockMyChoice
//
//  Created by Itsuki on 2026/01/17.
//

import SwiftUI
import FamilyControls

struct ApplyRestrictionView: View {
    @State private var blockManager = BlockManager()
    
    @State private var showActivitySelectionView = false
    @State private var showShieldConfigurationView = false

    var body: some View {
        let activitySelection = blockManager.activitySelection
        List {
            
            Section("Current Selections To Block") {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Applications: \(activitySelection.applicationTokens.count)")
                        Text("Categories: \(activitySelection.categoryTokens.count)")
                        Text("Web Domains: \(activitySelection.webDomainTokens.count)")
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                    Spacer()
                    
                    Button(action: {
                        showActivitySelectionView = true
                    }, label: {
                        Text("Pick Activities")
                            .padding(.vertical)
                            .padding(.leading)
                            .contentShape(Rectangle())
                    })
                    .buttonStyle(.borderless)
                }
            }
            
            Section("Shield Appearance / Action") {
                Button(action: {
                    showShieldConfigurationView = true
                }, label: {
                    Text("Configure Shield")
                })
                .buttonStyle(.borderless)
            }
            
            
            switch (blockManager.shieldApplied, blockManager.shouldPromptUpdateShield) {
            case (false, false):
                fullWidthButton(
                    title: "Apply Restrictions", action: {
                        self.blockManager.applyRestrictions()
                    },
                    foreground: .white, background: .blue, fontWeight: .semibold
                )
            case (true, true):
                fullWidthButton(
                    title: "Update Restrictions", action: {
                        self.blockManager.applyRestrictions()
                    },
                    foreground: .white, background: .blue, fontWeight: .semibold
                )
                
                fullWidthButton(
                    title: "Remove Restrictions", action: {
                        self.blockManager.removeRestrictions()
                    },
                    foreground: .blue, background: .gray.opacity(0.3), fontWeight: .medium
                )

            case (false, true):
                fullWidthButton(
                    title: "Apply Restrictions", action: {
                        self.blockManager.applyRestrictions()
                    },
                    foreground: .white, background: .blue, fontWeight: .semibold
                )

            case (true, false):
                fullWidthButton(
                    title: "Remove Restrictions", action: {
                        self.blockManager.removeRestrictions()
                    },
                    foreground: .white, background: .blue, fontWeight: .semibold
                )

            }

        }
        .contentMargins(.top, 16)
        .buttonStyle(.plain)
        .navigationTitle("Focus Time!")
        .sheet(isPresented: $showActivitySelectionView, content: {
            FamilyActivitySelectionView(selection: $blockManager.activitySelection)
        })
        
        .sheet(isPresented: $showShieldConfigurationView, content: {
            ShieldConfigurationView(configuration: $blockManager.appearanceConfiguration)
        })

        
    }
    
    @ViewBuilder
    private func fullWidthButton(
        title: String,
        action: @escaping () -> Void,
        foreground: Color,
        background: Color,
        fontWeight: Font.Weight
    ) -> some View {
        Section {
            Button(action: action, label: {
                Text(title)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundStyle(foreground)
                    .fontWeight(fontWeight)
            })
            .buttonStyle(.borderless)
            .buttonSizing(.flexible)
            .listRowBackground(background)
            
        }
        .listSectionMargins(.bottom, 8)
    }
}
