//
//  Date + Extension.swift
//  Know Your Customer
//
//  Created by Matt Novoselov on 23/07/25.
//

import Foundation

extension Date {
    var yearMonthDay: Date {
        let comps = Calendar.current.dateComponents([.year, .month, .day], from: self)
        return Calendar.current.date(from: comps)!
    }
}
