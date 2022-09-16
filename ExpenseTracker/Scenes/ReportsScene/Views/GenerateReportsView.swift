//
//  GenerateReportsView.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 8/4/22.
//

import SwiftUI

struct GenerateReportsView: View {
  @EnvironmentObject var coreVM: CoreDataManager
  
  @State private var startDate: Date  = Date.now
  @State private var endDate: Date    = Date.now
  
  var body: some View {
    NavigationView {
      Form {
        
        DatePicker("Start date", selection: $startDate, displayedComponents: [.date])
        
        DatePicker("End date", selection: $endDate, displayedComponents: [.date])
        
        NavigationLink(destination: ReportsView(startDate: $startDate, endDate: $endDate), label: {
          Text("Generate Report")
            .foregroundColor(.cyan)
            .centerInView()
        })
        .centerInView()
      }
      .navigationTitle("Create Reports")
    }
  }
}

struct GenerateReportsView_Previews: PreviewProvider {
  static var previews: some View {
    GenerateReportsView()
    GenerateReportsView()
      .preferredColorScheme(.dark)
  }
}