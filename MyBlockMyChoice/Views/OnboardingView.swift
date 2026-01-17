//
//  OnboardingView.swift
//  MyBlockMyChoice
//
//  Created by Itsuki on 2026/01/17.
//

import SwiftUI

struct OnboardingView: View {
    var images: [String] = [
        "Permission", "Select Activity", "Configure Appearance", "Apply Shield",
    ]
    @State private var currentStep: Int = 0
    
    @AppStorage("onboarding") var onboardingFinished: Bool = false

    var body: some View {
        VStack(spacing: 24) {
            
            VStack(alignment: .leading, spacing: 16, content: {
                Text(images[currentStep])
                    .font(.headline)
                Image(images[currentStep])
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            })
            
            HStack {
                Group {
                    if currentStep > 0 {
                        Button(action: {
                            currentStep -= 1
                        }, label: {
                            Text("Prev")
                        })
                    } else {
                        Spacer()
                    }
                }
                .frame(width: 120)
                
                Spacer()
                
                ForEach(0..<images.count, id: \.self) { index in
                    Circle()
                        .fill(Color.secondary.opacity(index == currentStep ? 0.8 : 0.3))
                        .frame(width: 12, height: 12)
                }
                
                Spacer()
               
                
                Group {
                    if currentStep < images.count - 1 {
                        Button(action: {
                            currentStep += 1
                        }, label: {
                            Text("Next")
                        })
                    } else if currentStep == images.count - 1 {
                        Button(action: {
                            onboardingFinished = true
                        }, label: {
                            Text("Finish")
                        })
                    }
                    
                    else {
                        Spacer()
                    }
                }
                .frame(width: 120)

                
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.all, 24)
        .navigationTitle("Onboarding")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.yellow.opacity(0.05))

    }
}


#Preview {
    OnboardingView()
}
