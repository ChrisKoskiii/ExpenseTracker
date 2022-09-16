//
//  ExpensesViewModel.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 8/11/22.
//

import Foundation
import SwiftUI

class ExpensesViewModel: ObservableObject {
  
  @Published var monthText: String = "January"
  @Published var yearText: String  = "1999"
  @Published var monthStart: Date  = Date.startOfMonth(Date.now)()
  @Published var monthEnd: Date    = Date.endOfMonth(Date.now)()
  
  @Published var newExpense: ExpenseModel?
  
  private var currentMonthShown: Date = Date.now
  
  init() {
    getCurrentMonthString(from: Date.now)
    getCurrentYearString(from: Date.now)
  }

  func setCurrentMonth() {
    currentMonthShown = Date.now
    getCurrentMonthString(from: currentMonthShown)
    getCurrentYearString(from: currentMonthShown)
  }
  
  func addMonth() {
    let newDate = Calendar.current.date(byAdding: .month, value: 1, to: currentMonthShown)!
    currentMonthShown = newDate
    getCurrentMonthString(from: newDate)
    getCurrentYearString(from: newDate)
    monthStart = Date.startOfMonth(newDate)()
    monthEnd = Date.endOfMonth(newDate)()
  }
  
  func subtractMonth() {
    let newDate = Calendar.current.date(byAdding: .month, value: -1, to: currentMonthShown)!
    currentMonthShown = newDate
    getCurrentMonthString(from: newDate)
    getCurrentYearString(from: newDate)
    monthStart = Date.startOfMonth(newDate)()
    monthEnd = Date.endOfMonth(newDate)()
  }
  
  func getCurrentMonthString(from date: Date) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "LLLL"
    monthText = dateFormatter.string(from: date)
  }
  
  func getCurrentYearString(from date: Date) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy"
    yearText = dateFormatter.string(from: date)
  }
}


