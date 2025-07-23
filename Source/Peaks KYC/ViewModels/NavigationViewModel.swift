//
//  NavigationViewModel.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 24/07/25.
//

import SwiftUI

@Observable
class NavigationViewModel {
    enum NavigationRoute: Hashable { case countryList, fieldsList, summary }
    var isViewControllerPresented = false
    var navigationPath = NavigationPath()

    func navigate(to route: NavigationRoute) {
        navigationPath.append(route)
    }
}
