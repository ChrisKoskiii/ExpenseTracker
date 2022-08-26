//
//  SettingsView.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 7/29/22.
//

import SwiftUI

struct SettingsView: View {
  @EnvironmentObject var coreVM: CoreDataViewModel
  
  
  var body: some View {
    Form {
      Text("Settings")
    }
    .navigationTitle("Settings")
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      SettingsView()
    }
  }
}
