//
//  NavigationViewModel 2.swift
//  Know Your Customer
//
//  Created by Matt Novoselov on 24/07/25.
//

import SwiftUI

@Observable
class AccessibilityViewModel {
    // Posts voice over announcements for accessibility users.
    func announce(_ message: String) {
        var announcement = AttributedString(message)
        announcement.accessibilitySpeechAnnouncementPriority = .high
        AccessibilityNotification.Announcement(announcement).post()
    }
}
