//
//  Peaks_KYCApp.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 18/07/25.
//

import SwiftUI

@main
struct PeaksKYCApp: App {
    @State private var dependencyContainer = DependencyContainer()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
                .environment(dependencyContainer)
                .environment(dependencyContainer.formManagerViewModel)
                .environment(dependencyContainer.navigationViewModel)
        }
    }
}
