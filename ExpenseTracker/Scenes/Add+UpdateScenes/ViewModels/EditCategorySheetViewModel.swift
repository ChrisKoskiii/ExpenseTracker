////
////  EditCategoryViewModel.swift
////  ExpenseTracker
////
////  Created by Christopher Koski on 9/27/22.
////
//
//import SwiftUI
//
//class EditCategorySheetViewModel: ObservableObject {
//
//  @Published var storedCategory: CategoryModel?
//  @Published var name = ""
//  @Published var symbolColor: Color = Color.brandPrimary
//  @Published var symbol: String = "photo"
//
//  func updateStoredCategory(with category: CategoryEntity) {
//    getModelFromCategory(category)
//    getColorFromCategory(category)
//    getSymbolFromCategory(category)
//    getNameFromCategory(category)
//  }
//
//  func getModelFromCategory(_ category: CategoryEntity) {
//    let categoryModel = CategoryModel(name: category.wrappedName,
//                                      symbol: category.wrappedSymbol,
//                                      colorR: category.colorR,
//                                      colorG: category.colorG,
//                                      colorB: category.colorB,
//                                      colorA: category.colorA)
//    storedCategory = categoryModel
//  }
//
//  func getColorFromCategory(_ category: CategoryEntity) {
//    symbolColor = category.computeColor()
//  }
//
//  func getSymbolFromCategory(_ category: CategoryEntity) {
//    symbol = category.wrappedSymbol
//  }
//
//  func getNameFromCategory(_ category: CategoryEntity) {
//    name = category.wrappedName
//  }
//}
