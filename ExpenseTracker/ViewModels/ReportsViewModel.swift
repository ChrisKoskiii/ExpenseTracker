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
  @Published var dateRangeExpenses: [ExpenseEntity] = []
  
}
