//
//  RecentExpenseCardView.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 7/28/22.
//

import SwiftUI
import CoreMotion

struct RecentExpenseCardView: View {
  @Environment(\.colorScheme) var colorScheme
  
  @EnvironmentObject var tools: GlobalTools
  
  @ObservedObject var recentExpense: ExpenseEntity
  
  
  var body: some View {
    ZStack {
      
      HStack {
        RecentSymbol(symbol: recentExpense.category.wrappedSymbol, color: Color.clear.getColor(from: recentExpense.category))
          .padding(.leading, 4)
        
        Divider()
          .frame(height: 40)
        
        VStack(alignment: .leading, spacing: 0) {
          Text(recentExpense.wrappedTitle)
            .foregroundColor(.recentTextColor)
            .lineLimit(1)
            .font(.headline)
            .padding(.top, 4)
          
          Text(recentExpense.vendor.wrappedName)
            .foregroundColor(.secondary)
            .font(.footnote)
          
          Text(recentExpense.wrappedDate.formatDate())
            .foregroundColor(.secondary)
            .font(.footnote)
            .padding(.bottom, 4)
        }
        Spacer()
        
        let costString = tools.myFormatter.string(from: NSNumber(value: recentExpense.cost))!.dropFirst()
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
      .cardBackground()
      .padding(.horizontal)
    }
  }
}

struct RecentExpenseCardView_Previews: PreviewProvider {
  static let coreVM =  CoreDataManager()
  
  static var previews: some View {
    
    let sampleExpense = ExpenseEntity(context: coreVM.container.viewContext)
    sampleExpense.title = "Text Expense"
    sampleExpense.date = Date.now
    sampleExpense.cost = 99.99
    
    
    return RecentExpenseCardView(recentExpense: sampleExpense).environment(\.managedObjectContext, coreVM.container.viewContext)
      .environmentObject(coreVM)
  }
}
