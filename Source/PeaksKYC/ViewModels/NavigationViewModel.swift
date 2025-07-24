//
//  NavigationViewModel.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 24/07/25.
//

import SwiftUI

@Observable
class NavigationViewModel {
    // Controls stack-based navigation inside the flow.
    enum NavigationRoute: Hashable { case countryList, fieldsList, summary }
    var isViewControllerPresented = false
    var navigationPath = NavigationPath()

    // Function to navigate to a selected path in the route.
    func navigate(to route: NavigationRoute) {
        navigationPath.append(route)
    }
}
