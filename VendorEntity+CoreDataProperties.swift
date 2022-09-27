//
//  VendorEntity+CoreDataProperties.swift
//  
//
//  Created by Christopher Koski on 9/27/22.
//
//

import Foundation
import CoreData


extension VendorEntity {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<VendorEntity> {
    return NSFetchRequest<VendorEntity>(entityName: "VendorEntity")
  }
  
  @NSManaged public var name: String?
  @NSManaged public var expense: NSSet?
  
  var wrappedName: String {
    get { name ?? "Unkown"}
    set { name = newValue }
  }
  
}

// MARK: Generated accessors for expense
extension VendorEntity {
  
  @objc(addExpenseObject:)
  @NSManaged public func addToExpense(_ value: ExpenseEntity)
  
  @objc(removeExpenseObject:)
  @NSManaged public func removeFromExpense(_ value: ExpenseEntity)
  
  @objc(addExpense:)
  @NSManaged public func addToExpense(_ values: NSSet)
  
  @objc(removeExpense:)
  @NSManaged public func removeFromExpense(_ values: NSSet)
  
}
