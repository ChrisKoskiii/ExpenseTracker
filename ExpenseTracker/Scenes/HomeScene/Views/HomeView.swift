//
//  HomeView.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 7/28/22.
//

import SwiftUI

struct HomeView: View {
  @Environment(\.scenePhase) var scenePhase
  
  @EnvironmentObject var dataManager:  CoreDataManager
  
  var body: some View {
    NavigationView {
      VStack {
        
        MonthlyTotalView(coreVM: dataManager)
        
        recentTransactionText
        
        RecentExpensesList(coreVM: dataManager)
        
        Spacer()
        
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
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
      .background(Color(uiColor: .systemGray5))
      .navigationTitle("Overview")
      .navigationBarTitleDisplayMode(.large)
    }
    .navigationViewStyle(.stack)
    .onChange(of: scenePhase) { _ in
      dataManager.fetchData()
    }
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
  var body: some View {
    ForEach(coreVM.recentExpenses, id: \.self) { expense in
      NavigationLink(destination: DetailExpenseView(detailExpense: expense)) {
        RecentExpenseCardView(recentExpense: expense)
      }
    }
  }
}

struct HomeView_Previews: PreviewProvider {
  static let coreVM = CoreDataManager()
  
  static var previews: some View {
    HomeView()
      .environmentObject(coreVM)
  }
}
