//
//  RecentExpenseCardView.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 7/28/22.
//

import SwiftUI
import CoreMotion

struct RecentExpenseCardView: View {
  
  var recentExpense: ExpenseEntity
  
  var formatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.maximumFractionDigits = 2
    return formatter
  }()
  
  var body: some View {
    ZStack {
      
      HStack {
        
        VStack(spacing: 0) {
          
          Text(recentExpense.wrappedDate.weekday())
            .font(.caption2)
            .kerning(2)
            .foregroundColor(.black)
            .lineLimit(1)
            .minimumScaleFactor(0.75)
          
          Text(recentExpense.wrappedDate.formatDate())
            .font(.title3)
            .bold()
            .kerning(2)
            .overlay(
              LinearGradient(colors: [.teal, .brandPrimary], startPoint: .leading, endPoint: .trailing)
            ).mask {
              Text(recentExpense.wrappedDate.formatDate())
                .font(.title3)
                .bold()
                .kerning(2)
            }
          
        }
        .frame(width: 70)
        .padding(.leading, 6)
        
        Divider()
          .frame(height: 40)
        
        VStack(alignment: .leading, spacing: 0) {
          Text(recentExpense.wrappedTitle)
            .foregroundColor(.black)
            .lineLimit(1)
            .font(.headline)
            .padding(.top, 4)
          
          Text(recentExpense.wrappedCategory)
            .foregroundColor(.secondary)
            .font(.footnote)
          
          Text(recentExpense.wrappedVendor)
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
            .foregroundColor(.black)
            Spacer().frame(height: 8)
          }
          Text(costString)
            .foregroundColor(.black)
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
  static let coreVM =  CoreDataViewModel()
  
  static var previews: some View {
    
    let sampleExpense = ExpenseEntity(context: coreVM.container.viewContext)
    sampleExpense.title = "Text Expense"
    sampleExpense.vendor = "Home-Depot"
    sampleExpense.category = "Supplies"
    sampleExpense.date = Date.now
    sampleExpense.cost = 99.99
    
    
    return RecentExpenseCardView(recentExpense: sampleExpense).environment(\.managedObjectContext, coreVM.container.viewContext)
      .environmentObject(coreVM)
  }
}
