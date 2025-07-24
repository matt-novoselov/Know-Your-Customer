//
//  HomeView.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

struct ContentView: View {
    // Hosts the welcome screen and starts the onboarding flow.
    @Environment(NavigationViewModel.self) private var navigationViewModel

    var body: some View {
        @Bindable var navigationViewModel = navigationViewModel

        WelcomeScreenView()
            .fullScreenCover(isPresented: $navigationViewModel.isViewControllerPresented) {
                FlowNavigationController()
            }
    }
}
