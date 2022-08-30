//
//  SettingsView.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 7/29/22.
//

import SwiftUI

struct SettingsView: View {
  
  @AppStorage("isDarkMode") private var isDarkMode = false
  
  @EnvironmentObject var coreVM: CoreDataViewModel

  
  var body: some View {
    NavigationView {
      Form {
        Section {
          Toggle("Dark Mode", isOn: $isDarkMode)
        } header: {
          Text("Appearance")
        }
        
      }
      .navigationTitle("Settings")
    }
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
  }
}
