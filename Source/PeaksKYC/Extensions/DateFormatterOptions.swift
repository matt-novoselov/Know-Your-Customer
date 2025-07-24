//
//  DateFormatterHolder.swift
//  PeaksKYC
//
//  Created by Matt Novoselov on 24/07/25.
//

import Foundation

public struct DateFormatterHolder {
    public static let medium: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}

extension DateFormatter {
    func string(from components: DateComponents?) -> String? {
        guard
            let comps = components,
            let date = Calendar.current.date(from: comps)
        else { return nil }
        return string(from: date)
    }
}
