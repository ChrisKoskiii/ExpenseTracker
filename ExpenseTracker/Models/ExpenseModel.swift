//
//  Expense.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 8/22/22.
//

import Foundation

struct ExpenseModel {
  var category: String
  var cost: Double
  var date: Date
  var title: String
  var vendor: String
  var receipt: Data?
}
