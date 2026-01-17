//
//  FamilyActivitySelectionView.swift
//  MyBlockMyChoice
//
//  Created by Itsuki on 2026/01/17.
//


import SwiftUI
import FamilyControls

struct FamilyActivitySelectionView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Binding var selection: FamilyActivitySelection
    
    @State private var selectionTemp: FamilyActivitySelection = FamilyActivitySelection()
    
    var body: some View {
        NavigationStack {
            FamilyActivityPicker(selection: $selectionTemp)
                .ignoresSafeArea()
                .navigationTitle("Select Activity")
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
                            selection = selectionTemp
                            self.dismiss()
                        }, label: {
                            Image(systemName: "checkmark")
                        })
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.circle)
                    })
                    .sharedBackgroundVisibility(.hidden)
                })
                .onChange(of: selection, initial: true, {
                    self.selectionTemp = selection
                })
        }

    }
}
