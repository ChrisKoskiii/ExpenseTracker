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
    if let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date()) {
      fetchDateRangeExpenses(startDate: startDate, endDate: Date.now, timeframe: TimeFrame.week)
    }
  }
  
  //MARK: Fetch functions
  
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
      fetchRecent(expenses: savedExpenses)
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
  
  func fetchRecent(expenses: [ExpenseEntity]) {
    recentExpenses = Array(savedExpenses.prefix(5))
  }
  
  func fetchDateRangeExpenses(startDate: Date, endDate: Date, timeframe: TimeFrame? = nil, completion: (([ExpenseEntity]) -> ())? = nil) {
    let request = NSFetchRequest<ExpenseEntity>(entityName: "ExpenseEntity")
    let sort = NSSortDescriptor(key: #keyPath(ExpenseEntity.date), ascending: false)
    
    let predicate = NSPredicate(format: "%@ >= date AND %@ <= date", argumentArray: [endDate, startDate])
    request.predicate = predicate
    request.sortDescriptors = [sort]
    
    do {
      let expenses = try container.viewContext.fetch(request)
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
      dateRangeExpenses = expenses
      categoryTotal()
      
    } catch let error {
      print("Error fetching expenses for date range, \(error)")
      
    }
  }
  
  func fetchAllCategories() {
    for expense in savedExpenses {
      categoriesDict[expense.category.wrappedName] = 0
    }
  }
  
  //MARK: Add functions
  
  func addExpense(_ expense: ExpenseModel) {
    let newExpense = ExpenseEntity(context: container.viewContext)
    newExpense.title = expense.title
    newExpense.cost = expense.cost
    newExpense.date = expense.date
    
    if let receiptData = expense.receipt {
      newExpense.receipt = receiptData
    }
    
    let categoryResult = isDuplicate(expense.category.name, "CategoryEntity")
    
    if categoryResult.isTrue {
      newExpense.category = categoryResult.returnedEntity! as! CategoryEntity//Safe to force unwrap, only returns true if there is something there
    } else {
      let newCategory = CategoryEntity(context: container.viewContext)
      newCategory.name = expense.category.name
      newCategory.symbol = expense.category.symbol
      newCategory.colorA = expense.category.colorA
      newCategory.colorB = expense.category.colorB
      newCategory.colorG = expense.category.colorG
      newCategory.colorR = expense.category.colorR
      
      newExpense.category = newCategory
    }
    
    let vendorResult = isDuplicate(expense.vendor.name, "VendorEntity")
    
    if vendorResult.isTrue {
      newExpense.vendor = vendorResult.returnedEntity! as! VendorEntity
    } else {
      let newVendor = VendorEntity(context: container.viewContext)
      newVendor.name = expense.vendor.name
      newExpense.vendor = newVendor
    }
    saveData()
  }
  
  func addCategory(_ category: CategoryModel) {
    
    let newCategory = CategoryEntity(context: container.viewContext)
    newCategory.name = category.name
    newCategory.symbol = category.symbol
    newCategory.colorR = category.colorR
    newCategory.colorG = category.colorG
    newCategory.colorB = category.colorB
    newCategory.colorA = category.colorA
    
    saveData()
  }
  
  func addVendor(_ vendor: VendorModel) {
    let newVendor = VendorEntity(context: container.viewContext)
    newVendor.name = vendor.name
    
    saveData()
  }
  
  //MARK: Delete function
  
  func deleteEntity(_ entity: NSManagedObject) {
    container.viewContext.delete(entity)
    saveData()
  }
  
  //MARK: Update functions
  
  func updateExpense(_ entity: ExpenseEntity, with expense: ExpenseModel) {
    entity.title = expense.title
    entity.cost = expense.cost
    entity.date = expense.date
    entity.receipt = expense.receipt
    
    let categoryResult = isDuplicate(expense.category.name, "CategoryEntity")
    if categoryResult.isTrue {
      entity.category = categoryResult.returnedEntity! as! CategoryEntity
    } else {
      entity.category.name = expense.category.name
      entity.category.symbol = expense.category.symbol
      entity.category.colorR = expense.category.colorR
      entity.category.colorG = expense.category.colorG
      entity.category.colorB = expense.category.colorB
      entity.category.colorA = expense.category.colorA
    }
    
    let vendorResult = isDuplicate(expense.vendor.name, "VendorEntity")
    if vendorResult.isTrue {
      entity.vendor = vendorResult.returnedEntity! as! VendorEntity
    } else {
      entity.vendor.name = expense.vendor.name
    }
    
    saveData()
  }
  
  func updateCategories() {
    fetchAllCategories()
  }
  
  //MARK: Save function
  
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
  
  //MARK: Misc functions
  
  func isDuplicate<T: NSManagedObject>(_ name: String, _ entityName: String) -> (isTrue: Bool, returnedEntity: T?) {
    
    let request = NSFetchRequest<T>(entityName: entityName)
    
    let query = name
    
    request.sortDescriptors = []
    request.predicate = NSPredicate(format: "name LIKE %@", query)
    
    do {
      let fetchedResult = try container.viewContext.fetch(request)
      print(fetchedResult as Any)
      if fetchedResult.isEmpty {
        return (false, nil)
      } else {
        return (true, fetchedResult.first)
      }
    } catch let error {
      print("Error checking for matched entry, \(error.localizedDescription)")
      return (false, nil)
    }
  }
  
  func getTotal(from expenses: [ExpenseEntity]) -> Double {
    return expenses.lazy.compactMap { $0.cost }
      .reduce(0, +)
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
  
  func categoryColor(for category: CategoryEntity) -> Color {
    return Color(red: category.colorR, green: category.colorG, blue: category.colorB, opacity: category.colorA)
  }
}

