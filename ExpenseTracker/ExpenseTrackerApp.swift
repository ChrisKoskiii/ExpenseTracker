//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 7/28/22.
//

import SwiftUI
import AppCenter
import AppCenterCrashes
import AppCenterAnalytics

@main
struct ExpenseTrackerApp: App {
  
  @AppStorage("isDarkMode") private var isDarkMode = false
  
  @StateObject var coreVM     = CoreDataManager()
  @StateObject var globals    = GlobalTools()
  
  var body: some Scene {
    WindowGroup {
      TabViewScreen()
        .environmentObject(coreVM)
        .environmentObject(globals)
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .onAppear {
           UITableView.appearance().backgroundColor = .systemGray5
        }
    }
  }
}
