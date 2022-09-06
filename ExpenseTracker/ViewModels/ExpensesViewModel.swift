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
  @Published var monthStart: Date = Date.startOfMonth(Date.now)()
  @Published var monthEnd: Date = Date.endOfMonth(Date.now)()
  @Published var selectedCategory: CategoryModel?
  @Published var selectedVendor: String?
  @Published var newExpense: ExpenseModel?
  
  private var currentMonthShown: Date = Date.now
  
  init() {
    getCurrentMonthString(from: Date.now)
  }

  func setCurrentMonth() {
    currentMonthShown = Date.now
    getCurrentMonthString(from: currentMonthShown)
  }
  
  func addMonth() {
    let newDate = Calendar.current.date(byAdding: .month, value: 1, to: currentMonthShown)!
    currentMonthShown = newDate
    getCurrentMonthString(from: newDate)
    monthStart = Date.startOfMonth(newDate)()
    monthEnd = Date.endOfMonth(newDate)()
  }
  
  func subtractMonth() {
    let newDate = Calendar.current.date(byAdding: .month, value: -1, to: currentMonthShown)!
    currentMonthShown = newDate
    getCurrentMonthString(from: newDate)
    monthStart = Date.startOfMonth(newDate)()
    monthEnd = Date.endOfMonth(newDate)()
  }
  
  func getCurrentMonthString(from date: Date) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "LLLL"
    monthText = dateFormatter.string(from: date)
  }
  
  func makeNewExpense(category: String, cost: Double, date: Date, title: String, vendor: String, receipt: Data?, symbol: String, colorR: Double, colorG: Double, colorB: Double, colorA: Double, completion: (ExpenseModel) -> ()) {
    let categoryModel = CategoryModel(name: category, symbol: symbol, colorR: colorR, colorG: colorG, colorB: colorB, colorA: colorA)
    let vendorModel = VendorModel(name: vendor)
    let expense = ExpenseModel(category: categoryModel, cost: cost, date: date, title: title, vendor: vendorModel, receipt: receipt)
    completion(expense)
  }
  
  func newCategory(name: String, symbol: String, colorR: Double, colorG: Double, colorB: Double, colorA: Double) {
    selectedCategory = CategoryModel(name: name, symbol: symbol, colorR: colorR, colorG: colorG, colorB: colorB, colorA: colorA)
  }
  
  func categoryEntityToModel(_ category: CategoryEntity) -> CategoryModel {
    let myModel = CategoryModel(name: category.wrappedName, symbol: category.wrappedSymbol, colorR: category.colorR, colorG: category.colorG, colorB: category.colorB, colorA: category.colorA)
    return myModel
  }
  
  func categoryColor() -> Color {
    if let category = selectedCategory {
    return Color(red: category.colorR, green: category.colorG, blue: category.colorB, opacity: category.colorA)
    }
    return Color.brandPrimary
  }
}


