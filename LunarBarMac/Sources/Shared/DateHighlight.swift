//
//  DateHighlight.swift
//  LunarBarMac
//
//  Created by cyan on 11/9/26.
//

import Foundation
import LunarBarKit

/**
 Tracks which day is highlighted in the date grid.

 By default the highlight follows today; clicking a day moves the highlight to it,
 without opening the system Calendar app.
 */
@MainActor
enum DateHighlight {
  /// The explicitly selected date, `nil` when the highlight should follow today.
  private(set) static var selectedDate: Date?

  /// The date the focus ring should be drawn on.
  static var highlightedDate: Date {
    selectedDate ?? .now
  }

  /// Posted after the highlight has moved to another day.
  static let didChangeNotification = Notification.Name("DateHighlightDidChange")

  /// Moves the highlight to the specified date.
  static func select(_ date: Date) {
    guard !Calendar.solar.isDate(date, inSameDayAs: highlightedDate) else {
      return
    }

    selectedDate = date
    NotificationCenter.default.post(name: didChangeNotification, object: nil)
  }

  /// Lets the highlight follow today again.
  static func reset() {
    guard selectedDate != nil else {
      return
    }

    selectedDate = nil
    NotificationCenter.default.post(name: didChangeNotification, object: nil)
  }
}
