//
//  SettingsView.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 7/29/22.
//

import SwiftUI

struct SettingsView: View {
  
  @EnvironmentObject var coreVM: CoreDataViewModel
  @State private var lightOn = true
  @State private var darkOn = false
  var body: some View {
    NavigationView {
      Form {
        Toggle("LightMode", isOn: $lightOn)
        Toggle("Dark Mode", isOn: $darkOn)
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
