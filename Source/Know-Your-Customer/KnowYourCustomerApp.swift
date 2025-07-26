//
//  Know Your Customer App.swift
//  Know Your Customer
//
//  Created by Matt Novoselov on 18/07/25.
//

import SwiftUI

@main
struct KnowYourCustomerApp: App {
    // Entry point of the SwiftUI application.
    @State private var dependencyContainer = DependencyContainer()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
                .environment(dependencyContainer)
                .environment(dependencyContainer.formManagerViewModel)
                .environment(dependencyContainer.navigationViewModel)
                .environment(dependencyContainer.accessibilityViewModel)
        }
    }
}
