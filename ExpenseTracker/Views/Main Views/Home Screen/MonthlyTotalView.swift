//
//  MonthlyTotalView.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 7/30/22.
//

import SwiftUI

struct MonthlyTotalView: View {
  
  @ObservedObject var coreVM: CoreDataManager
  @StateObject var homeVM =   HomeViewModel()
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      
      VStack(spacing: 16) {
        
        //"This week so far" with menu button
        HStack(spacing: 0) {
          ThisWeekString(text: "This ")
          MenuView(homeVM: homeVM, coreVM: coreVM)
          ThisWeekString(text: " so far:")
          Spacer()
        }
        
        //Large total string
        Text("$"+String(format: "%.2f", homeVM.total))
          .font(.largeTitle)
          .bold()
      }
      .frame(maxWidth: .infinity)
      .padding(.horizontal)
      .padding(.top, 4)
    }
    .padding(.horizontal)
    
    //Fetches current weekly total on launch
    .onAppear {
      if let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date()) {
        coreVM.getDateRangeExpenses(startDate: startDate, endDate: Date.now){ expenses in
          homeVM.dateRangeExpenses = expenses
        }
      }
      homeVM.setViewTotal(text: "week", total: coreVM.weeklyTotal)
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
  @ObservedObject var homeVM: HomeViewModel
  var coreVM: CoreDataManager
  var body: some View {
    Menu {
      
      Button("week", action: {
        if let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date()) {
          
          coreVM.getDateRangeExpenses(startDate: startDate, endDate: Date.now, timeframe: TimeFrame.week)
          homeVM.setViewTotal(text: "week", total: coreVM.weeklyTotal)
          print(coreVM.weeklyTotal)
        }
        
        
      })
      
      Button("month", action: {
        if let startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date()) {
          
          coreVM.getDateRangeExpenses(startDate: startDate, endDate: Date.now, timeframe: TimeFrame.month)
          homeVM.setViewTotal(text: "month", total: coreVM.monthlyTotal)
          print(coreVM.monthlyTotal)
        }
        
        
      })
      
      Button("year", action: {
        if let startDate = Calendar.current.date(byAdding: .year, value: -1, to: Date()) {
          
          coreVM.getDateRangeExpenses(startDate: startDate, endDate: Date.now, timeframe: TimeFrame.year)
          homeVM.setViewTotal(text: "year", total: coreVM.yearlyTotal)
          print(coreVM.yearlyTotal)
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
    MonthlyTotalView(coreVM: CoreDataManager())
  }
}
