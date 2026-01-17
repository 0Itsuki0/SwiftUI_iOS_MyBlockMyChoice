//
//  AuthorizationView.swift
//  MyBlockMyChoice
//
//  Created by Itsuki on 2026/01/17.
//

import SwiftUI
import FamilyControls

struct AuthorizationView: View {
    
    @ObservedObject private var center = AuthorizationCenter.shared
    
    var body: some View {
        Group {
            switch center.authorizationStatus {
            case .notDetermined:
                ContentUnavailableView(label: {
                    Label("Unknown Access", systemImage: "questionmark.app")
                }, description: {
                    Text("The app requires access to family control.")
                        .multilineTextAlignment(.center)
                }, actions: {
                    Button(action: {
                        Task {
                            await BlockManager.requestFamilyControlAuthorization()
                        }
                    }, label: {
                        Text("request access")
                    })
                })

            case .denied:
                ContentUnavailableView(label: {
                    Label("Access Denied", systemImage: "xmark.square")
                }, description: {
                    Text("The app doesn't have permission to family control. Please grant the app access in Settings.")
                        .multilineTextAlignment(.center)
                })
            case .approved:
                ApplyRestrictionView()
           
            @unknown default:
                ContentUnavailableView(label: {
                    Label("Unknown", systemImage: "ellipsis.rectangle")
                }, description: {
                    Text("Unknown authorization status.")
                        .multilineTextAlignment(.center)
                })
            }

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.yellow.opacity(0.05))
    }
}
