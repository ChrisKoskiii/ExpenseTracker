//
//  Date+Extension.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 7/29/22.
//

import Foundation

extension Date {
  func formatDate() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.setLocalizedDateFormatFromTemplate("M/dd")
    return dateFormatter.string(from: self)
  }
  
  func addOrSubtractMonth(month: Int) -> Date {
    Calendar.current.date(byAdding: .month, value: month, to: Date())!
  }
  
  func addOrSubtractYear(year: Int) -> Date {
    Calendar.current.date(byAdding: .year, value: year, to: Date())!
  }
  
  func startOfMonth() -> Date {
    return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
  }
  
  func endOfMonth() -> Date {
    return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
  }
  
  func weekday() -> String {
    let f = DateFormatter()

    return f.weekdaySymbols[Calendar.current.component(.weekday, from: self) - 1]
  }
}
