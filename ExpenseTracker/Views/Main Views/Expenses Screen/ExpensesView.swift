//
//  ExpensesView.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 7/29/22.
//

import SwiftUI

struct ExpensesView: View {

  @EnvironmentObject var coreVM:  CoreDataManager
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
        endDate: expensesVM.monthEnd, timeframe: TimeFrame.month)
    }
    .navigationViewStyle(.stack)
  }
  
  var expenseList: some View {
    
    List {
      
      ForEach(coreVM.monthlyExpenses, id: \.self) { expense in
        
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
            let costString = formatter.string(from: NSNumber(value: expense.cost))!
            Text(costString)
              .font(.title3)
          }
        }
      }
    }
    //allows for pull to refresh
    .refreshable {

    }
  }
}

struct AddExpenseButton: View {
  @ObservedObject var coreVM: CoreDataManager
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
  @ObservedObject var coreVM: CoreDataManager
  @ObservedObject var expensesVM: ExpensesViewModel
  var body: some View {
    HStack {
      Button {
        expensesVM.subtractMonth()
        coreVM.getDateRangeExpenses(
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
        coreVM.getDateRangeExpenses(
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
