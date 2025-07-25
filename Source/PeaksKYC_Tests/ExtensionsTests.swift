//
//  ExtensionsTests.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 23/07/25.
//

import Testing
@testable import PeaksKYC
import Foundation

@Suite("Extensions")
struct ExtensionsTests {
    // Tests helper extensions for date handling.

    @Test("Date yearMonthDay Conversion")
    func testYearMonthDay() {
        let date = Date(timeIntervalSince1970: 0).yearMonthDay
        let comps = Calendar.current.dateComponents([.year, .month, .day], from: date)
        #expect(comps.year == 1970 && comps.month == 1 && comps.day == 1)
    }

    @Test("DateFormatter String From Date")
    func testFormatter() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        let components = DateComponents(year: 2024, month: 7, day: 25)
        let date = Calendar.current.date(from: components)!

        let str = formatter.string(from: date)
        #expect(str == "2024-07-25")
    }
}
