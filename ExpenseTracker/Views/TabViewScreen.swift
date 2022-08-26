//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 7/28/22.
//

import SwiftUI

struct TabViewScreen: View {
  @EnvironmentObject var coreVM: CoreDataViewModel
  
  @ObservedObject var expensesVM: ExpensesViewModel
  var body: some View {
    TabView {
      HomeView(expensesVM: expensesVM)
        .tabItem {
          Label("Home", systemImage: "house")
        }
      ExpensesView(expensesVM: expensesVM)
        .tabItem {
          Label("Expenses", systemImage: "dollarsign.circle")
        }
      GenerateReportsView()
        .tabItem {
          Label("Reports", systemImage: "list.bullet.rectangle.portrait")
        }
      SettingsView()
        .tabItem {
          Label("Settings", systemImage: "gear")
        }
    }
    .accentColor(Color.brandPrimary)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    TabViewScreen(expensesVM: ExpensesViewModel())
  }
}
