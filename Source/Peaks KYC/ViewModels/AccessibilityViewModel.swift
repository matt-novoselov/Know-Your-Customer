//
//  NavigationViewModel 2.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 24/07/25.
//

import SwiftUI

@Observable
class AccessibilityViewModel {
    func announce(_ message: String) {
        var announcement = AttributedString(message)
        announcement.accessibilitySpeechAnnouncementPriority = .high
        AccessibilityNotification.Announcement(announcement).post()
    }
}
