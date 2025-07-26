//
//  DateFormatterHolder.swift
//  Know Your Customer
//
//  Created by Matt Novoselov on 24/07/25.
//

import Foundation

/// Convenient access to a medium style date formatter reused across the app.
public struct DateFormatterHolder {
    public static let medium: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}
