//
//  ExpensesView.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 7/29/22.
//

import SwiftUI

struct ExpensesView: View {

  @EnvironmentObject var dataManager: CoreDataManager
  @EnvironmentObject var tools:       GlobalTools
  @ObservedObject var expensesVM:     ExpensesViewModel
  
  var body: some View {
    NavigationView {
      
      expenseList
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          
          ToolbarItem(placement: .navigationBarTrailing) {
            AddExpenseButton(dataManager: dataManager, expensesVM: expensesVM)
          }
          
          ToolbarItem(placement: .principal) {
            MonthSelector(dataManager: dataManager, expensesVM: expensesVM)
          }
        }
    }
    .task {
      dataManager.getDateRangeExpenses(
        startDate: expensesVM.monthStart,
        endDate: expensesVM.monthEnd, timeframe: TimeFrame.month)
    }
    .navigationViewStyle(.stack)
  }
  
  var expenseList: some View {
    
    List {
      
      ForEach(dataManager.monthlyExpenses, id: \.self) { expense in
        
        NavigationLink(destination: DetailExpenseView(expensesVM: expensesVM, detailExpense: expense)) {
          
          HStack {
            Text(expense.wrappedDate.formatDate())
            
            VStack(alignment: .leading) {
              Text(expense.wrappedTitle)
              Text(expense.vendor.wrappedName)
                .font(.footnote)
              Text(expense.category.wrappedName)
                .font(.footnote)
            }
            
            Spacer()
            let costString = tools.myFormatter.string(from: NSNumber(value: expense.cost))!
            Text(costString)
              .font(.title3)
          }
        }
      }
    }
    .refreshable {
      dataManager.getDateRangeExpenses(
        startDate: expensesVM.monthStart,
        endDate: expensesVM.monthEnd, timeframe: TimeFrame.month)
    }
  }
}

struct AddExpenseButton: View {
  @ObservedObject var dataManager: CoreDataManager
  @ObservedObject var expensesVM: ExpensesViewModel
  
  var body: some View {
    NavigationLink(destination: AddExpenseView()) {
      ZStack {
        Circle()
          .frame(width: 30, height: 30)
          .foregroundColor(Color.brandPrimary)
        Image(systemName: "plus")
          .foregroundColor(.white)
      }
    }
  }
}

struct MonthSelector: View {
  @ObservedObject var dataManager: CoreDataManager
  @ObservedObject var expensesVM: ExpensesViewModel
  var body: some View {
    HStack {
      Button {
        expensesVM.subtractMonth()
        dataManager.getDateRangeExpenses(
          startDate: expensesVM.monthStart,
          endDate: expensesVM.monthEnd, timeframe: TimeFrame.month)
      } label: {
        Image(systemName: "chevron.left")
          .font(.footnote)
      }
      Text(expensesVM.monthText)
        .lineLimit(1)
        .minimumScaleFactor(0.75)
        .frame(width: 80)
      Button {
        expensesVM.addMonth()
        dataManager.getDateRangeExpenses(
          startDate: expensesVM.monthStart,
          endDate: expensesVM.monthEnd, timeframe: TimeFrame.month)
      } label: {
        Image(systemName: "chevron.right")
          .font(.footnote)
      }
    }
  }
}

struct ExpensesView_Previews: PreviewProvider {
  static let coreVM = CoreDataManager()
  
  static var previews: some View {
    ExpensesView(expensesVM: ExpensesViewModel())
      .environmentObject(coreVM)
    ExpensesView(expensesVM: ExpensesViewModel())
      .environmentObject(coreVM)
      .preferredColorScheme(.dark)
  }
}
