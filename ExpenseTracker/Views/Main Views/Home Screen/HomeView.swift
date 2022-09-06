//
//  HomeView.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 7/28/22.
//

import SwiftUI

struct HomeView: View {
  
  @EnvironmentObject var coreVM:  CoreDataManager
  @ObservedObject var expensesVM: ExpensesViewModel
  
  var body: some View {
    NavigationView {
      VStack {
        
        MonthlyTotalView(coreVM: coreVM)
        
        recentTransactionText
        
        RecentExpensesList(coreVM: coreVM, expensesVM: expensesVM)
        
        Spacer()
        
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
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
      .background(Color(uiColor: .systemGray5))
      .navigationTitle("Overview")
      .navigationBarTitleDisplayMode(.large)
    }
    .navigationViewStyle(.stack)
  }
  
  var recentTransactionText: some View {
    HStack {
      Text("Recent activity:")
        .font(.caption)
        .foregroundColor(.secondary)
        .padding(.leading)
        .padding(.top, 16)
      Spacer()
    }
  }
  
}

struct RecentExpensesList: View {
  @ObservedObject var coreVM: CoreDataManager
  @ObservedObject var expensesVM: ExpensesViewModel
  var body: some View {
    ForEach(coreVM.recentExpenses, id: \.self) { expense in
      NavigationLink(destination: DetailExpenseView(expensesVM: expensesVM, detailExpense: expense)) {
        RecentExpenseCardView(recentExpense: expense)
      }
    }
  }
}

struct HomeView_Previews: PreviewProvider {
  static let coreVM = CoreDataManager()
  
  static var previews: some View {
    HomeView(expensesVM: ExpensesViewModel())
      .environmentObject(coreVM)
  }
}
