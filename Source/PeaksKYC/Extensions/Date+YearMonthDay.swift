//
//  Date + Extension.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 23/07/25.
//

import Foundation

extension Date {
    /// Extracts only the year, month and day components of the date.
    var yearMonthDay: DateComponents {
        Calendar.current.dateComponents([.year, .month, .day], from: self)
    }
}
