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
  
  
  @State var opacity = 1.0
  @State var scale: CGFloat = 1
  
  var repeatingAnimation: Animation {
    Animation
      .easeInOut(duration: 1.5)
      .repeatForever()
  }
  var body: some View {
    NavigationView {
      VStack {
        
        MonthlyTotalView(dataManager: dataManager)
        
        recentTransactionText
        
        if dataManager.recentExpenses.isEmpty {
          VStack {
            Spacer()
            Image(systemName: "rectangle.and.pencil.and.ellipsis")
              .resizable()
              .scaledToFit()
              .frame(height: 100)
              .foregroundColor(Color.secondary)
            Text("Start adding expenses!")
              .font(.title)
              .foregroundColor(Color.secondary)
              .fontWeight(.semibold)
            Spacer()
            Spacer()
          }
        } else {
          RecentExpensesList(coreVM: dataManager)
        }
        
        Spacer()
        
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          NavigationLink(destination: AddExpenseView()) {
            
            ZStack {
              if dataManager.recentExpenses.isEmpty {
                Circle()
                  .stroke(lineWidth: 40)
                  .frame(width: 1, height: 1)
                  .foregroundColor(Color.brandPrimary)
                  .scaleEffect(scale)
                  .opacity(opacity)
                  .onAppear{
                      scale = 1.5
                      opacity = 0.1
                  }
                  .animation(repeatingAnimation, value: [scale, opacity])
              }
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
