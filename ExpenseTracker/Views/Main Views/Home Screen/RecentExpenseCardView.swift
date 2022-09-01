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
  
  var recentExpense: ExpenseEntity
  
  var formatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.maximumFractionDigits = 2
    return formatter
  }()
  
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
          
          Text(recentExpense.category.wrappedName)
            .foregroundColor(.secondary)
            .font(.footnote)
          
          Text(recentExpense.category.wrappedName)
            .foregroundColor(.secondary)
            .font(.footnote)
            .padding(.bottom, 4)
        }
        Spacer()
        
        let costString = formatter.string(from: NSNumber(value: recentExpense.cost))!
        
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

//     VStack(spacing: 0) {
//
//          Text(recentExpense.wrappedDate.weekday())
//            .font(.caption2)
//            .kerning(2)
//            .foregroundColor(.recentTextColor)
//            .lineLimit(1)
//            .minimumScaleFactor(0.75)
//
//          Text(recentExpense.wrappedDate.formatDate())
//            .font(.title3)
//            .bold()
//            .kerning(2)
//            .overlay(
//              LinearGradient(colors: [.teal, .brandPrimary], startPoint: .leading, endPoint: .trailing)
//            ).mask {
//              Text(recentExpense.wrappedDate.formatDate())
//                .font(.title3)
//                .bold()
//                .kerning(2)
//            }
//
//        }
//        .frame(width: 70)
//        .padding(.leading, 6)
