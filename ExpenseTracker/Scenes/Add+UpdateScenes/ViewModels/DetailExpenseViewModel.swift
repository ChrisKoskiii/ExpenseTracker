//
//  DetailExpenseViewModel.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 9/6/22.
//

import SwiftUI

class DetailExpenseViewModel: ObservableObject {
  @Published var selectedCategory: CategoryModel? {
    didSet {
      color = Color.clear.getColor(from: self.selectedCategory!)
      categorySymbol = self.selectedCategory!.symbol
    }
  }
  @Published var selectedVendor: VendorModel?
  
  @Published var title: String = ""
  @Published var cost: Double = 0.0
  @Published var vendorName: String = ""
  @Published var categoryName: String = ""
  @Published var categorySymbol: String = "photo"
  @Published var date: Date = Date.now
  @Published var color: Color = .brandPrimary

  @Published var showScanner = false
  
  func getDetails(from expense: ExpenseEntity) {
    let category = getCategoryModel(from: expense.category)
    title = expense.wrappedTitle
    cost = expense.cost
    vendorName = getVendorModel(from: expense.vendor).name
    categoryName = category.name
    categorySymbol = category.symbol
    color = Color.clear.getColor(from: category)
    date = expense.wrappedDate
  }
  
  func getExpenseModel(from expense: ExpenseEntity) -> ExpenseModel {
    let myModel = ExpenseModel(category: getCategoryModel(from: expense.category),
                               cost: expense.cost,
                               date: expense.wrappedDate,
                               title: expense.wrappedTitle,
                               vendor: getVendorModel(from: expense.vendor))
    return myModel
  }
  
  func getCategoryModel(from category: CategoryEntity) -> CategoryModel {
    let myCategory = CategoryModel(name: category.wrappedName, symbol: category.wrappedSymbol, colorR: category.colorR, colorG: category.colorG, colorB: category.colorB, colorA: category.colorA)
    
    return myCategory
  }
  
  func getVendorModel(from vendor: VendorEntity) -> VendorModel {
    let myVendor = VendorModel(name: vendor.wrappedName)
    return myVendor
  }
  
  func makeNewExpense(category: String, cost: Double, date: Date, title: String, vendor: String, receipt: Data?, symbol: String, colorR: Double, colorG: Double, colorB: Double, colorA: Double, completion: (ExpenseModel) -> ()) {
    let categoryModel = CategoryModel(name: category, symbol: symbol, colorR: colorR, colorG: colorG, colorB: colorB, colorA: colorA)
    let vendorModel   = VendorModel(name: vendor)
    let expense       = ExpenseModel(category: categoryModel, cost: cost, date: date, title: title, vendor: vendorModel, receipt: receipt)
    completion(expense)
  }
  
  func getImageData(_ image: UIImage) -> Data {
    return image.jpegData(compressionQuality: 1.0)!
  }
}
