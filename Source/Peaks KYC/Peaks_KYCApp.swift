//
//  Peaks_KYCApp.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 18/07/25.
//

import SwiftUI

@main
struct Peaks_KYCApp: App {
    @State private var signUpViewModel = SignUpViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
                .environment(signUpViewModel)
        }
    }
}
