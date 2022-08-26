//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 7/28/22.
//

import SwiftUI
import UIKit
import AppCenter
import AppCenterCrashes
import AppCenterAnalytics

@main
struct ExpenseTrackerApp: App {
  
  init() {
    AppCenter.start(withAppSecret: "bf883fcb-7f36-4617-b5f4-36a2652cf667",
                    services: [
                      Analytics.self,
                      Crashes.self])
  }
  
  @StateObject var coreVM     = CoreDataViewModel()
  @StateObject var expensesVM = ExpensesViewModel()
  
  var body: some Scene {
    WindowGroup {
      TabViewScreen(expensesVM: expensesVM)
        .environmentObject(coreVM)
    }
  }
}
