import Testing
@testable import Peaks_KYC
import SwiftUI

@Suite("NavigationViewModel")
struct NavigationViewModelTests {
    @Test("navigate adds route")
    func testNavigate() {
        let vm = NavigationViewModel()
        vm.navigate(to: .summary)
        #expect(vm.navigationPath.contains(.summary))
    }
}
