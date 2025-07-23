//
//  Peaks_KYCApp.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 18/07/25.
//

import SwiftUI

@main
struct PeaksKYCApp: App {
    @State private var formManagerViewModel = FormManagerViewModel()
    @State private var navigationViewModel = NavigationViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
                .environment(formManagerViewModel)
                .environment(navigationViewModel)
        }
    }
}
