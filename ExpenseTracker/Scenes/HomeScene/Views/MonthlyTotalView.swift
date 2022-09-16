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
  @StateObject var viewModel =     TotalsManager()
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      
      VStack(spacing: 16) {
        
        HStack(spacing: 0) {
          ThisWeekString(text: "This ")
          MenuView(homeVM: viewModel, coreVM: dataManager)
          ThisWeekString(text: " so far:")
          Spacer()
        }
        
        Text("$"+String(format: "%.2f", viewModel.total))
          .font(.largeTitle)
          .bold()
      }
      .frame(maxWidth: .infinity)
      .padding(.horizontal)
      .padding(.top, 4)
    }
    .padding(.horizontal)

    .onChange(of: scenePhase) { _ in
      if let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date()) {
        dataManager.fetchDateRangeExpenses(startDate: startDate, endDate: Date.now, timeframe: TimeFrame.week)
        viewModel.setViewTotal(text: "week", total: dataManager.weeklyTotal)
      }
    }
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

struct MenuView: View {
  @ObservedObject var homeVM: TotalsManager
  var coreVM: CoreDataManager
  var body: some View {
    Menu {
      
      Button("week", action: {
        if let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date()) {
          
          coreVM.fetchDateRangeExpenses(startDate: startDate, endDate: Date.now, timeframe: TimeFrame.week)
          homeVM.setViewTotal(text: "week", total: coreVM.weeklyTotal)
        }
        
        
      })
      
      Button("month", action: {
        if let startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date()) {
          
          coreVM.fetchDateRangeExpenses(startDate: startDate, endDate: Date.now, timeframe: TimeFrame.month)
          homeVM.setViewTotal(text: "month", total: coreVM.monthlyTotal)
        }
        
        
      })
      
      Button("year", action: {
        if let startDate = Calendar.current.date(byAdding: .year, value: -1, to: Date()) {
          
          coreVM.fetchDateRangeExpenses(startDate: startDate, endDate: Date.now, timeframe: TimeFrame.year)
          homeVM.setViewTotal(text: "year", total: coreVM.yearlyTotal)
        }
      })
      
    } label: {
      timeFrameButtonText(text: homeVM.selectedTimeFrame)
    }
  }
}

struct ThisWeekString: View {
  var text: String
  var body: some View {
    Text(text)
      .font(.callout)
      .foregroundColor(.secondary)
  }
}

struct MonthlyTotalView_Previews: PreviewProvider {
  static var previews: some View {
    MonthlyTotalView(dataManager: CoreDataManager())
  }
}