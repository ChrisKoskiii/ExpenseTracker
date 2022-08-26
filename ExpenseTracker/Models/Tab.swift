//
//  Tab.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 7/28/22.
//

import SwiftUI

struct TabItem: Identifiable {
  var id = UUID()
  var text: String
  var icon: String
  var tab: Tab
  var color: Color
}

var tabItems = [
  TabItem(text: "Dashboard", icon: "house", tab: .home, color: .teal),
  TabItem(text: "Expenses", icon: "dollarsign.square.fill", tab: .expenses, color: .blue),
  TabItem(text: "Reports", icon: "doc.text.fill", tab: .reports, color: .red),
  TabItem(text: "Settings", icon: "gear", tab: .settings, color: .pink)
]

enum Tab: String {
  case home
  case expenses
  case reports
  case settings
}

struct TabPreferenceKey: PreferenceKey {
  static var defaultValue: CGFloat = 0
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = nextValue()
  }
}
