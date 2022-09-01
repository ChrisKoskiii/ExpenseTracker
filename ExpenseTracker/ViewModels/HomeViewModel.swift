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
  
  func setViewTotal(text: String, total: Double) {
    selectedTimeFrame = text
    self.total = total
  }
  func getSelectedTotal(from expenses: [ExpenseEntity]) {
    dateRangeExpenses = expenses
    if selectedTimeFrame == "week" {
      total = getTotal(from: dateRangeExpenses)
      print(total)
    } else if selectedTimeFrame == "month" {
      total = getTotal(from: dateRangeExpenses)
      print(total)
    } else if selectedTimeFrame == "year" {
      total = getTotal(from: dateRangeExpenses)
      print(total)
    }
  }
  
  func getTotal(from expenses: [ExpenseEntity]) -> Double {
    return expenses.lazy.compactMap { $0.cost }
      .reduce(0, +)
  }
}
