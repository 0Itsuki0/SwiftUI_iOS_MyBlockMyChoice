//
//  ContentView.swift
//  MyBlockMyChoice
//
//  Created by Itsuki on 2026/01/17.
//

import SwiftUI
import FamilyControls

struct ContentView: View {
    @AppStorage("onboarding") var onboardingFinished: Bool = false

    var body: some View {
        NavigationStack {
            if onboardingFinished {
                AuthorizationView()
            } else {
                OnboardingView()
            }
            
        }
    }
}





#Preview {
    NavigationStack {
        ContentView()
    }
}
