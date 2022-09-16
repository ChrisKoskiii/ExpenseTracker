//
//  MonthSelectorView.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 9/15/22.
//

import SwiftUI

struct MonthSelectorView: View {
  @ObservedObject var dataManager: CoreDataManager
  @ObservedObject var viewModel: ExpensesViewModel
  
  var body: some View {
    HStack {
      Button {
        withAnimation(.easeInOut) {
          viewModel.subtractMonth()
          dataManager.fetchDateRangeExpenses(
            startDate: viewModel.monthStart,
            endDate: viewModel.monthEnd, timeframe: TimeFrame.month)
        }
      } label: {
        Image(systemName: "chevron.left")
          .font(.title3)
      }
      VStack {
        Text(viewModel.monthText)
          .font(.title3)
          .fontWeight(.medium)
          .lineLimit(1)
          .minimumScaleFactor(0.75)
          .frame(width: 100)
        Text(viewModel.yearText)
          .fontWeight(.light)
          .lineLimit(1)
          .minimumScaleFactor(0.75)
          .frame(width: 80)
      }
      Button {
        withAnimation(.easeInOut) {
          viewModel.addMonth()
          dataManager.fetchDateRangeExpenses(
            startDate: viewModel.monthStart,
            endDate: viewModel.monthEnd, timeframe: TimeFrame.month)
        }
      } label: {
        Image(systemName: "chevron.right")
          .font(.title3)
      }
    }
  }
}

//struct MonthSelectorView_Previews: PreviewProvider {
//    static var previews: some View {
//      MonthSelectorView(dataManager: , viewModel: )
//    }
//}
