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
  @State private var systemOn = false
  
  var body: some View {
    NavigationView {
      Form {
        Section {
          Toggle("Light Mode", isOn: $lightOn)
            .onChange(of: darkOn) { newValue in
              withAnimation {
                lightOn = !newValue
              }
            }
          Toggle("Dark Mode", isOn: $darkOn)
            .onChange(of: lightOn) { newValue in
              withAnimation {
                darkOn = !newValue
              }
            }
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
