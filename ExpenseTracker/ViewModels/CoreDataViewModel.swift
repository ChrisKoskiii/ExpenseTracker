//
//  CoreDataViewModel.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 7/28/22.
//

import CoreData
import UIKit
import CloudKit

class CoreDataViewModel: ObservableObject {
  
  let container: NSPersistentContainer
  
  @Published var savedExpenses: [ExpenseEntity] = []
  @Published var recentExpenses: [ExpenseEntity] = []
  @Published var monthlyTotal: Double = 0.00
  @Published var dateRangeExpenses: [ExpenseEntity] = []
  @Published var dateRangeTotal: Double = 0.0
  @Published var categoriesDict: [String: Double] = [:]
  
  init() {
    container = NSPersistentCloudKitContainer(name: "ExpenseContainer")
    container.loadPersistentStores { description, error in
      if let error = error {
        print("Error loading Core Data, \(error)")
      }
    }
    container.viewContext.automaticallyMergesChangesFromParent = true
    container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    fetchExpenses()
    getRecent(expenses: savedExpenses)
    if let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date()) {
      getDateRangeExpenses(startDate: startDate, endDate: Date.now) { expenses in
        dateRangeExpenses = expenses
      }
    }
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
  
  func getRecent(expenses: [ExpenseEntity]) {
    recentExpenses = Array(savedExpenses.prefix(5))
  }
  
  func getDateRangeExpenses(startDate: Date, endDate: Date , completion: ([ExpenseEntity]) -> ()) {
    let request = NSFetchRequest<ExpenseEntity>(entityName: "ExpenseEntity")
    let sort = NSSortDescriptor(key: #keyPath(ExpenseEntity.date), ascending: false)
    
    let predicate = NSPredicate(format: "%@ >= date AND %@ <= date", argumentArray: [endDate, startDate])
    request.predicate = predicate
    request.sortDescriptors = [sort]
    
    do {
      let expenses = try container.viewContext.fetch(request)
      dateRangeTotal = getTotal(from: dateRangeExpenses)
      completion(expenses)
      
    } catch let error {
      print("Error fetching expenses for date range, \(error)")
      
    }
  }
  
  func addExpense(_ expense: ExpenseModel) {
    let newExpense = ExpenseEntity(context: container.viewContext)
    newExpense.title = expense.title
    newExpense.cost = expense.cost
    newExpense.vendor = expense.vendor
    newExpense.category = expense.category
    newExpense.date = expense.date
    if let receiptData = expense.receipt {
      newExpense.receipt = receiptData
    }
    
    saveData()
  }
  
  func deleteExpense(_ expense: ExpenseEntity) {
      let entity = expense
      container.viewContext.delete(entity)
    
      saveData()
    }
  
  func updateExpense(_ entity: ExpenseEntity, with expense: ExpenseModel) {
    entity.title = expense.title
    entity.cost = expense.cost
    entity.vendor = expense.vendor
    entity.category = expense.category
    entity.date = expense.date
    entity.receipt = expense.receipt
    
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
        if expense.wrappedCategory == key {
          var newValue = value
          newValue += expense.cost
          categoriesDict.updateValue(newValue, forKey: key)
        }
      }
    }
  }
  
  func getAllCategories() {
    for expense in savedExpenses {
      categoriesDict[expense.wrappedCategory] = 0
    }
  }
}

