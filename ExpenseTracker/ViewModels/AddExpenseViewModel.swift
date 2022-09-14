//
//  AddExpenseViewModel.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 9/6/22.
//

import SwiftUI
import Combine

class AddExpenseViewModel: ObservableObject {
  @Published var cameraIsPresented    = false
  @Published var showScanner          = false
  @Published var isRecognizing        = false
  
  @Published var presentAlert         = false
  
  @Published var titleText: String    = ""
  @Published var costText             = 0.00
  @Published var dateValue: Date      = Date.now
  @Published var categoryText: String = "Select Category"
  @Published var vendorText: String   = "Select Vendor"
  @Published var symbol: String       = "photo"
  
  @Published var color: Color?
  
  @Published var imageData: Data?
  @Published var scannedImage: UIImage?
  
  @Published var selectedCategory: CategoryModel? {
    didSet {
      color = Color.clear.getColor(from: self.selectedCategory!)
    }
  }
  @Published var selectedVendor: VendorModel?
  
  func makeNewExpense(category: CategoryModel, vendor: VendorModel, date: Date, completion: (ExpenseModel) -> ()) {
    let newExpense = ExpenseModel(category: category,
                                  cost: costText,
                                  date: date,
                                  title: titleText,
                                  vendor: vendor,
                                  receipt: imageData)
    completion(newExpense)
  }
  
  func getSymbolColor(from category: CategoryModel) {
    color = Color.clear.getColor(from: category)
  }
}
