//
//  CategoryViewModel.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 9/5/22.
//

import SwiftUI

class CategoryViewModel: ObservableObject {
  
  @Published var storedCategory: CategoryModel?
  
  func makeCategoryModel(name: String, symbol: String, colorR: Double, colorG: Double, colorB: Double, colorA: Double) {
    let newCategory = CategoryModel(name: name, symbol: symbol, colorR: colorR, colorG: colorG, colorB: colorB, colorA: colorA)
    storedCategory = newCategory
  }
}
