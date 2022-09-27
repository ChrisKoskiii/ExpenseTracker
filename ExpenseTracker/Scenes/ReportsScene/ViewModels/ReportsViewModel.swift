//
//  ReportsViewModel.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 8/8/22.
//

import Foundation

class ReportsViewModel: ObservableObject {
  
  @Published var PDFUrl: URL?
  @Published var showShareSheet: Bool = false
  @Published var total = 0.0
  
  func getTotal(from expenses: [ExpenseEntity]) {
    var newTotal = 0.0
    for expense in expenses {
      newTotal += expense.cost
    }
    total = newTotal
  }
}
