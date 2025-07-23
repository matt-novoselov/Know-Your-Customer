//
//  Date + Extension.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 23/07/25.
//

import Foundation

extension Date {
  var yearMonthDay: DateComponents {
    Calendar.current.dateComponents([.year, .month, .day], from: self)
  }
}
