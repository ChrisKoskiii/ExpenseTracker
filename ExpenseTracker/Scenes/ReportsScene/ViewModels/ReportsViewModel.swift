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
  @Published var total: Double = 0.0
  
  func getTotal(from expenses: [ExpenseEntity]) {
    for expense in expenses {
      total += expense.cost
    }
  }
}
