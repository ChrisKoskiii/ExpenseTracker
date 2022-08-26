//
//  ExpenseEntity+CoreDataProperties.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 7/31/22.
//
//

import Foundation
import CoreData


extension ExpenseEntity {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<ExpenseEntity> {
    return NSFetchRequest<ExpenseEntity>(entityName: "ExpenseEntity")
  }
  
  @NSManaged public var category: String?
  @NSManaged public var cost: Double
  @NSManaged public var date: Date?
  @NSManaged public var title: String?
  @NSManaged public var vendor: String?
  @NSManaged public var receipt: Data?
  
  var wrappedCategory: String {
    get { category ?? "Unknown" }
    set { category = newValue }
  }
  
  var wrappedDate: Date {
    get { date ?? Date.now }
    set { date = newValue }
  }
  
  var wrappedTitle: String {
    get { title ?? "Unknown" }
    set { title = newValue }
  }
  
  var wrappedVendor: String {
    get { vendor ?? "Unknown" }
    set { vendor = newValue }
  }
}

extension ExpenseEntity : Identifiable {
  
}
