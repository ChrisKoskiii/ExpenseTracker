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
  
  @State private var isLeft = false
  
  var body: some View {
    NavigationView {
      
      expenseList
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          
          ToolbarItem(placement: .principal) {
            MonthSelector(dataManager: dataManager, expensesVM: expensesVM, isLeft: $isLeft)
          }
        }
    }
    .onAppear {
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
            RecentSymbol(symbol: expense.category.wrappedSymbol, color: Color.clear.getColor(from: expense.category))
              .padding(.leading, 4)
            
            VStack(alignment: .leading, spacing: 0) {
              Text(expense.wrappedTitle)
                .foregroundColor(.recentTextColor)
                .lineLimit(1)
                .font(.headline)
              
              Text(expense.vendor.wrappedName)
                .foregroundColor(.secondary)
                .font(.footnote)
              
              Text(expense.wrappedDate.formatDate())
                .foregroundColor(.secondary)
                .font(.footnote)
            }
            Spacer()
            
            let costString = tools.myFormatter.string(from: NSNumber(value: expense.cost))!.dropFirst()
            HStack(spacing: 0) {
              VStack {
                Text("$")
                  .font(.footnote)
                  .foregroundColor(.recentTextColor)
                Spacer().frame(height: 8)
              }
              Text(costString)
                .foregroundColor(.recentTextColor)
                .font(.title2)
                .fontWeight(.semibold)
            }
            .padding(.trailing, 6)
          }
        }
      }
      //      .listRowBackground(Color.clear)
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
  @Binding var isLeft: Bool
  var body: some View {
    HStack {
      Button {
        withAnimation(.easeInOut) {
          expensesVM.subtractMonth()
          dataManager.getDateRangeExpenses(
            startDate: expensesVM.monthStart,
            endDate: expensesVM.monthEnd, timeframe: TimeFrame.month)
        }
      } label: {
        Image(systemName: "chevron.left")
          .font(.title3)
      }
      VStack {
        Text(expensesVM.monthText)
          .font(.title3)
          .fontWeight(.medium)
          .lineLimit(1)
          .minimumScaleFactor(0.75)
          .frame(width: 100)
        Text(expensesVM.yearText)
          .fontWeight(.light)
          .lineLimit(1)
          .minimumScaleFactor(0.75)
          .frame(width: 80)
      }
      Button {
        withAnimation(.easeInOut) {
          expensesVM.addMonth()
          dataManager.getDateRangeExpenses(
            startDate: expensesVM.monthStart,
            endDate: expensesVM.monthEnd, timeframe: TimeFrame.month)
        }
      } label: {
        Image(systemName: "chevron.right")
          .font(.title3)
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
