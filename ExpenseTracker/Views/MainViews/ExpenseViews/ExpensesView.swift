//
//  ExpensesView.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 7/29/22.
//

import SwiftUI

struct ExpensesView: View {
  @EnvironmentObject var coreVM: CoreDataViewModel
  @ObservedObject var expensesVM: ExpensesViewModel
  
  var formatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.maximumFractionDigits = 2
    return formatter
  }()
  
  var body: some View {
    NavigationView {
      expenseList
        .background(Color(.secondarySystemBackground))
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .navigationBarTrailing) {
            AddExpenseButton(coreVM: coreVM, expensesVM: expensesVM)
          }
          ToolbarItem(placement: .principal) {
            MonthSelector(coreVM: coreVM, expensesVM: expensesVM)
          }
        }
    }
    .onAppear {
      coreVM.getDateRangeExpenses(
        startDate: expensesVM.monthStart,
        endDate: expensesVM.monthEnd) { expenses in
          expensesVM.dateRangeExpenses = expenses
        }
    }
  }
  
  var expenseList: some View {
    List {
      
      ForEach(expensesVM.dateRangeExpenses) { expense in
        
        NavigationLink(destination: DetailExpenseView(expensesVM: expensesVM, detailExpense: expense)) {
          
          HStack {
            Text(expense.wrappedDate.formatDate())
            
            VStack(alignment: .leading) {
              Text(expense.wrappedTitle)
              Text(expense.wrappedVendor)
                .font(.footnote)
              Text(expense.wrappedCategory)
                .font(.footnote)
            }
            
            Spacer()
            let costString = formatter.string(from: NSNumber(value: expense.cost))!
            Text(costString)
              .font(.title3)
          }
        }
      }
    }
    //allows for pull to refresh
    .refreshable {
      coreVM.getDateRangeExpenses(
        startDate: expensesVM.monthStart,
        endDate: expensesVM.monthEnd) { expenses in
          expensesVM.dateRangeExpenses = expenses
        }
    }
    .listStyle(.plain)
  }
}

struct AddExpenseButton: View {
  @ObservedObject var coreVM: CoreDataViewModel
  @ObservedObject var expensesVM: ExpensesViewModel
  
  var body: some View {
    NavigationLink(destination: AddExpenseView(expensesVM: expensesVM)) {
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
  @ObservedObject var coreVM: CoreDataViewModel
  @ObservedObject var expensesVM: ExpensesViewModel
  var body: some View {
    HStack {
      Button {
        expensesVM.subtractMonth()
        coreVM.getDateRangeExpenses(
          startDate: expensesVM.monthStart,
          endDate: expensesVM.monthEnd) { expenses in
            expensesVM.dateRangeExpenses = expenses
          }
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
        coreVM.getDateRangeExpenses(
          startDate: expensesVM.monthStart,
          endDate: expensesVM.monthEnd) { expenses in
            expensesVM.dateRangeExpenses = expenses
          }
      } label: {
        Image(systemName: "chevron.right")
          .font(.footnote)
      }
    }
  }
}

struct ExpensesView_Previews: PreviewProvider {
  static var previews: some View {
    ExpensesView(expensesVM: ExpensesViewModel())
  }
}
