//
//  GenerateReportsView.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 8/4/22.
//

import SwiftUI

struct GenerateReportsView: View {
  @EnvironmentObject var dataManager: CoreDataManager
  
  @State private var startDate: Date  = Date.now.startOfDay
  @State private var endDate: Date    = Date.now
  
  @State var showingSheet = false
  
  var body: some View {
    NavigationView {
      Form {
        
        DatePicker("Start date", selection: $startDate, displayedComponents: [.date])
        
        DatePicker("End date", selection: $endDate, displayedComponents: [.date])
        
        Button {
          dataManager.fetchDateRangeExpenses(startDate: startDate, endDate: endDate)
          showingSheet.toggle()
        } label: {
          Text("Generate Report")
            .foregroundColor(.cyan)
            .centerInView()
        }
        .centerInView()
      }
      .navigationTitle("Create Reports")
      .sheet(isPresented: $showingSheet) {
        ReportsSheetView(startDate: $startDate, endDate: $endDate , showingSheet: $showingSheet)
      }
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
