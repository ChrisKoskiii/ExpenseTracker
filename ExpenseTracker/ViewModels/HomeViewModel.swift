//
//  HomeViewModel.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 8/11/22.
//

import Foundation

class HomeViewModel: ObservableObject {
  @Published var total: Double = 0.0
  @Published var selectedTimeFrame = "week"
  @Published var dateRangeExpenses: [ExpenseEntity] = []
  
  func setViewTotal(text: String, expenses: [ExpenseEntity]) {
    selectedTimeFrame = text
    getSelectedTotal(from: expenses)
    
  }
  func getSelectedTotal(from expenses: [ExpenseEntity]) {
    dateRangeExpenses = expenses
    if selectedTimeFrame == "week" {
      total = getTotal(from: dateRangeExpenses)
    } else if selectedTimeFrame == "month" {
      total = getTotal(from: dateRangeExpenses)
    } else if selectedTimeFrame == "year" {
      total = getTotal(from: dateRangeExpenses)
    }
  }
  
  func getTotal(from expenses: [ExpenseEntity]) -> Double {
    return expenses.lazy.compactMap { $0.cost }
      .reduce(0, +)
  }
}
