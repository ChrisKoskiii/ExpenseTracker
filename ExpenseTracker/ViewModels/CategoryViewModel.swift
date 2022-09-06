//
//  CategoryViewModel.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 9/5/22.
//

import SwiftUI

class CategoryViewModel: ObservableObject {
  
  @Published var storedCategory: CategoryModel?
  
  @Published var name = ""
  @Published var symbol = "photo"
  @Published var red = 0.0
  @Published var green = 0.0
  @Published var blue = 0.0
  @Published var alpha = 0.0
  
  func makeCategoryModel() {
    let newCategory = CategoryModel(name: name, symbol: symbol, colorR: red, colorG: green, colorB: blue, colorA: alpha)
    storedCategory = newCategory
  }
}
