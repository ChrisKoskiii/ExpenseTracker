//
//  CoreDataViewModel.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 7/28/22.
//

import CoreData
import UIKit
import SwiftUI
import CloudKit

class CoreDataManager: ObservableObject {
  
  let container: NSPersistentContainer
  
  @Published var savedExpenses: [ExpenseEntity] = []
  @Published var savedCategories: [CategoryEntity] = []
  @Published var savedVendors: [VendorEntity] = []
  @Published var recentExpenses: [ExpenseEntity] = []
  @Published var dateRangeExpenses: [ExpenseEntity] = []
  @Published var monthlyExpenses: [ExpenseEntity] = []
  @Published var categoriesDict: [String: Double] = [:]
  @Published var weeklyTotal: Double = 0.0
  @Published var monthlyTotal: Double = 0.0
  @Published var yearlyTotal: Double = 0.0
  @Published var dateRangeTotal: Double = 0.0
  
  init() {
    container = NSPersistentCloudKitContainer(name: "ExpenseContainer")
    container.loadPersistentStores { description, error in
      if let error = error {
        print("Error loading Core Data, \(error)")
      }
    }
    container.viewContext.automaticallyMergesChangesFromParent = true
    container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    fetchData()
    getRecent(expenses: savedExpenses)
    if let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date()) {
      getDateRangeExpenses(startDate: startDate, endDate: Date.now, timeframe: TimeFrame.week)
    }
  }
  
  func fetchData() {
    fetchExpenses()
    fetchCategories()
    fetchVendors()
  }
  
  func fetchExpenses() {
    let request = NSFetchRequest<ExpenseEntity>(entityName: "ExpenseEntity")
    let sort = NSSortDescriptor(key: #keyPath(ExpenseEntity.date), ascending: false)
    request.sortDescriptors = [sort]
    
    do {
      savedExpenses = try container.viewContext.fetch(request)
      getRecent(expenses: savedExpenses)
      monthlyTotal = getTotal(from: savedExpenses)
      updateCategories()
      
    } catch let error {
      print("Error fetching, \(error)")
      
    }
  }
  
  func fetchCategories() {
    let request = NSFetchRequest<CategoryEntity>(entityName: "CategoryEntity")
    let sort = NSSortDescriptor(key: #keyPath(CategoryEntity.name), ascending: false)
    request.sortDescriptors = [sort]
    
    do {
      savedCategories = try container.viewContext.fetch(request)
      
    } catch let error {
      print("Error fetching, \(error)")
      
    }
    
  }
  
  func fetchVendors() {
    let request = NSFetchRequest<VendorEntity>(entityName: "VendorEntity")
    let sort = NSSortDescriptor(key: #keyPath(VendorEntity.name), ascending: false)
    request.sortDescriptors = [sort]
    
    do {
      savedVendors = try container.viewContext.fetch(request)
      
    } catch let error {
      print("Error fetching, \(error)")
      
    }
  }
  
  func getRecent(expenses: [ExpenseEntity]) {
    recentExpenses = Array(savedExpenses.prefix(5))
  }
  
  func getDateRangeExpenses(startDate: Date, endDate: Date, timeframe: TimeFrame? = nil, completion: (([ExpenseEntity]) -> ())? = nil) {
    let request = NSFetchRequest<ExpenseEntity>(entityName: "ExpenseEntity")
    let sort = NSSortDescriptor(key: #keyPath(ExpenseEntity.date), ascending: false)
    
    let predicate = NSPredicate(format: "%@ >= date AND %@ <= date", argumentArray: [endDate, startDate])
    request.predicate = predicate
    request.sortDescriptors = [sort]
    
    do {
      let expenses = try container.viewContext.fetch(request)
      dateRangeTotal = getTotal(from: dateRangeExpenses)
      if let safeTimeframe = timeframe {
        switch safeTimeframe {
        case .week:
          weeklyTotal = getTotal(from: expenses)
          dateRangeExpenses = expenses
        case .month:
          monthlyTotal = getTotal(from: expenses)
          monthlyExpenses = expenses
        case .year:
          yearlyTotal = getTotal(from: expenses)
        }
      }
      
    } catch let error {
      print("Error fetching expenses for date range, \(error)")
      
    }
  }
  
  func addExpense(_ expense: ExpenseModel) {
    let newExpense = ExpenseEntity(context: container.viewContext)
    newExpense.title = expense.title
    newExpense.cost = expense.cost
    newExpense.date = expense.date
    
    if let receiptData = expense.receipt {
      newExpense.receipt = receiptData
    }
    
    let newCategory = CategoryEntity(context: container.viewContext)
    newCategory.name = expense.category.name
    newCategory.symbol = expense.category.symbol
    newCategory.colorA = expense.category.colorA
    newCategory.colorB = expense.category.colorB
    newCategory.colorG = expense.category.colorG
    newCategory.colorR = expense.category.colorR
    
    newExpense.category = newCategory
    
    let newVendor = VendorEntity(context: container.viewContext)
    newVendor.name = expense.vendor.name
    
    newExpense.vendor = newVendor
    
    saveData()
  }
  
  func addCategory(_ category: CategoryModel) {
    let newCategory = CategoryEntity(context: container.viewContext)
    newCategory.name = category.name
    newCategory.symbol = category.symbol
    newCategory.colorR = category.colorR
    newCategory.colorG = category.colorG
    newCategory.colorB = category.colorG
    newCategory.colorA = category.colorA
    
    saveData()
  }
  
  func addVendor(_ vendor: VendorModel) {
    let newVendor = VendorEntity(context: container.viewContext)
    newVendor.name = vendor.name
    
    saveData()
  }
  
  //Maybe we can reduce three delete functions to one with generics?
  func deleteExpense(_ expense: ExpenseEntity) {
    container.viewContext.delete(expense)
    saveData()
  }
  func deleteCategory(_ category: CategoryEntity) {
    container.viewContext.delete(category)
    saveData()
  }
  func deleteVendor(_ vendor: VendorEntity) {
    container.viewContext.delete(vendor)
    saveData()
  }
  
  func updateExpense(_ entity: ExpenseEntity, with expense: ExpenseModel) {
    entity.title = expense.title
    entity.cost = expense.cost
    entity.vendor.name = expense.vendor.name
    entity.category.name = expense.category.name
    entity.category.symbol = expense.category.symbol
    entity.date = expense.date
    entity.receipt = expense.receipt
    entity.category.colorR = expense.category.colorR
    entity.category.colorG = expense.category.colorG
    entity.category.colorB = expense.category.colorB
    entity.category.colorA = expense.category.colorA
    
    saveData()
  }
  
  func saveData() {
    do {
      try container.viewContext.save()
      fetchExpenses()
      monthlyTotal = getTotal(from: savedExpenses)
      updateCategories()
    } catch let error {
      print("Error saving , \(error)")
    }
  }
  
  func getImageData(_ image: UIImage) -> Data {
    return image.jpegData(compressionQuality: 1.0)!
  }
  
  func getTotal(from expenses: [ExpenseEntity]) -> Double {
    return expenses.lazy.compactMap { $0.cost }
      .reduce(0, +)
  }
  
  func updateCategories() {
    getAllCategories()
  }
  
  func categoryTotal() {
    for expense in dateRangeExpenses {
      for (key, value) in categoriesDict {
        if expense.category.wrappedName == key {
          var newValue = value
          newValue += expense.cost
          categoriesDict.updateValue(newValue, forKey: key)
        }
      }
    }
  }
  
  func getAllCategories() {
    for expense in savedExpenses {
      categoriesDict[expense.category.wrappedName] = 0
    }
  }
  
  func categoryColor(for category: CategoryEntity) -> Color {
    return Color(red: category.colorR, green: category.colorG, blue: category.colorB, opacity: category.colorA)
  }
}

