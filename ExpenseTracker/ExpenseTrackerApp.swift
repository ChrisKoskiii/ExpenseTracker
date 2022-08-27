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
  
  init() {
    AppCenter.start(withAppSecret: "98cd03c8-e864-49d0-9918-43184332e3ba",
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
