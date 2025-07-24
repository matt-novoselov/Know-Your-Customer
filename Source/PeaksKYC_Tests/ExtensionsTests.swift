import Testing
@testable import PeaksKYC
import Foundation

@Suite("Extensions")
struct ExtensionsTests {
    // Tests helper extensions for date handling.

    @Test("yearMonthDay components")
    func testYearMonthDay() {
        let comps = Date(timeIntervalSince1970: 0).yearMonthDay
        #expect(comps.year == 1970 && comps.month == 1 && comps.day == 1)
    }

    @Test("DateFormatter string from components")
    func testFormatter() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let comps = DateComponents(year: 2024, month: 7, day: 25)
        let str = formatter.string(from: comps)
        #expect(str == "2024-07-25")
        #expect(formatter.string(from: nil) == nil)
    }
}
