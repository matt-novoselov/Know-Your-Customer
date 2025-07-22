//
//  File.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 22/07/25.
//

import Foundation

extension DateFormatter {
    func string(from components: DateComponents?) -> String? {
        guard
            let comps = components,
            let date = Calendar.current.date(from: comps)
        else { return nil }
        return string(from: date)
    }
}
