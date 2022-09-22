//
//  MonthlyTotalView.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 7/30/22.
//

import SwiftUI

struct MonthlyTotalView: View {
  
  @Environment(\.scenePhase) var scenePhase
  
  @ObservedObject var dataManager: CoreDataManager
  
  @State private var timeFrame: TimeFrame = .week
  
  @State var selectedTimeFrame = "week"
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      
      VStack(spacing: 16) {
        
        HStack(spacing: 0) {
          Text("This")
            .font(.callout)
            .foregroundColor(.secondary)
          
          Menu {
            
            Button("week", action: {
              if let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date()) {
                
                dataManager.fetchDateRangeExpenses(startDate: startDate, endDate: Date.now, timeframe: TimeFrame.week)

                timeFrame = .week
                selectedTimeFrame = "week"
              }
            })
            
            Button("month", action: {
              if let startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date()) {
                
                dataManager.fetchDateRangeExpenses(startDate: startDate, endDate: Date.now, timeframe: TimeFrame.month)
                
                timeFrame = .month
                selectedTimeFrame = "month"
              }
            })
            
            Button("year", action: {
              if let startDate = Calendar.current.date(byAdding: .year, value: -1, to: Date()) {
                
                dataManager.fetchDateRangeExpenses(startDate: startDate, endDate: Date.now, timeframe: TimeFrame.year)
                
                timeFrame = .year
                selectedTimeFrame = "year"
              }
            })
            
          } label: {
            timeFrameButtonText(text: selectedTimeFrame)
          }
          
          Text(" so far.")
            .font(.callout)
            .foregroundColor(.secondary)
          
          Spacer()
        }
        
        switch timeFrame {
        case .week :
          TotalText(total: $dataManager.weeklyTotal)
        case .month:
          TotalText(total: $dataManager.monthlyTotal)
        case .year:
          TotalText(total: $dataManager.yearlyTotal)
        }
        
      }
      .frame(maxWidth: .infinity)
      .padding(.horizontal)
      .padding(.top, 4)
    }
    .padding(.horizontal)
  }
}

struct timeFrameButtonText: View {
  var text: String
  var body: some View {
    HStack(spacing: 0) {
      Text(text)
        .font(.callout)
        .bold()
      Image(systemName: "arrowtriangle.down.fill")
        .font(.caption)
    }
    .frame(width: 70)
    .foregroundColor(Color.brandPrimary)
    .overlay(Capsule()
      .stroke(Color.secondary, lineWidth: 1)
    )
  }
}

struct TotalText: View {
  @Binding var total: Double
  var body: some View {
    Text("$"+String(format: "%.2f", total))
      .font(.largeTitle)
      .bold()
  }
}

struct MonthlyTotalView_Previews: PreviewProvider {
  static var previews: some View {
    MonthlyTotalView(dataManager: CoreDataManager())
  }
}
