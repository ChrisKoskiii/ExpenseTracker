//
//  AddExpenseViewModel.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 9/6/22.
//

import SwiftUI
import Combine

class AddExpenseViewModel: ObservableObject {
  @Published var cameraIsPresented  = false
  @Published var showScanner        = false
  @Published var isRecognizing      = false
  
  @Published var presentAlert       = false
  
  @Published var titleText: String    = ""
  @Published var costText             = 0.00
  @Published var dateValue: Date      = Date.now
  @Published var categoryText: String = "Select Category"
  @Published var vendorText: String   = "Select Vendor"
  
  @Published var imageData: Data?
  @Published var scannedImage: UIImage?
  
  @Published var selectedCategory: CategoryModel?
  @Published var selectedVendor: VendorModel?
  
  var formatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.maximumFractionDigits = 2
    return formatter
  }()
  
  
  func makeNewExpense(category: CategoryModel, vendor: VendorModel, date: Date, completion: (ExpenseModel) -> ()) {
    let newExpense = ExpenseModel(category: category,
                                  cost: costText,
                                  date: date,
                                  title: titleText,
                                  vendor: vendor,
                                  receipt: imageData)
    completion(newExpense)
  }
}
