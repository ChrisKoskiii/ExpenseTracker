//
//  GenerateReportsView.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 8/4/22.
//

import SwiftUI

struct GenerateReportsView: View {
  @EnvironmentObject var coreVM: CoreDataViewModel
  
  @State private var startDate: Date = Date.now
  @State private var endDate: Date = Date.now
  @State private var selectedChoice = "Full Report"
  
  var reportChoices = ["Full Report", "Summary"]
  
  var body: some View {
    NavigationView {
      Form {
          DatePicker("Start date", selection: $startDate, displayedComponents: [.date])
          DatePicker("End date", selection: $endDate, displayedComponents: [.date])
          Picker("Full Report or Summary", selection: $selectedChoice) {
            ForEach(reportChoices, id: \.self) {
              Text($0)
            }
          }
          .pickerStyle(.segmented)
          NavigationLink(destination: ReportsView(startDate: startDate, endDate: endDate), label: {
          Text("Generate Report")
            .foregroundColor(.cyan)
            .centerInView()
        })
        .centerInView()
        .navigationTitle("Create Reports")
      }
    }
  }
}

struct GenerateReportsView_Previews: PreviewProvider {
  static var previews: some View {
    GenerateReportsView()
  }
}
