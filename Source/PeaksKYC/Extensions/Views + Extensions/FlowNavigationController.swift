//
//  FlowNavigationController.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 20/07/25.
//

import SwiftUI

struct FlowNavigationController: View {
    @Environment(NavigationViewModel.self) private var navigationViewModel

    var body: some View {
        @Bindable var navigationViewModel = navigationViewModel

        NavigationStack(path: $navigationViewModel.navigationPath) {
            CountryListView()
                .flowNavigationModifier()
        }
    }
}

struct FlowNavigationModifier: ViewModifier {
    @Environment(FormViewModel.self) private var formManagerViewModel

    func body(content: Content) -> some View {
        content
            .navigationDestination(for: NavigationViewModel.NavigationRoute.self) { route in
                Group {
                    switch route {
                    case .countryList:
                        CountryListView()
                    case .fieldsList:
                        InputFieldsListView()
                    case .summary:
                        SummaryView(entries: formManagerViewModel.getSummaryItems())
                    }
                }
                .gradientOverlay(height: 150, edge: .top)
            }
    }
}

extension View {
    func flowNavigationModifier() -> some View {
        modifier(FlowNavigationModifier())
    }
}
