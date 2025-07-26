//
//  HomeView.swift
//  Know Your Customer
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

// Hosts the welcome screen and starts the onboarding flow.
struct ContentView: View {
    @Environment(NavigationViewModel.self) private var navigationViewModel

    var body: some View {
        @Bindable var navigationViewModel = navigationViewModel

        WelcomeScreenView()
            .fullScreenCover(isPresented: $navigationViewModel.isViewControllerPresented) {
                FlowNavigationController()
            }
    }
}
