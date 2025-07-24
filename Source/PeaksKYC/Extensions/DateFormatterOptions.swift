//
//  DateFormatterHolder.swift
//  PeaksKYC
//
//  Created by Matt Novoselov on 24/07/25.
//

import Foundation

public struct DateFormatterHolder {
    /// Convenient access to a medium style date formatter reused across the app.
    public static let medium: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}

extension DateFormatter {
    /// Convenience helper to format optional date components.
    func string(from components: DateComponents?) -> String? {
        guard
            let comps = components,
            let date = Calendar.current.date(from: comps)
        else { return nil }
        return string(from: date)
    }
}
