//
//  CategoryEntity+CoreDataProperties.swift
//  
//
//  Created by Christopher Koski on 9/1/22.
//
//

import Foundation
import CoreData


extension CategoryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryEntity> {
        return NSFetchRequest<CategoryEntity>(entityName: "CategoryEntity")
    }

    @NSManaged public var colorA: Double
    @NSManaged public var colorB: Double
    @NSManaged public var colorG: Double
    @NSManaged public var colorR: Double
    @NSManaged public var name: String?
    @NSManaged public var symbol: String?
    @NSManaged public var expense: NSSet?
  
  var wrappedName: String {
    get { name ?? "Unknown" }
    set { name = newValue }
  }
  
  var wrappedSymbol: String {
    get { symbol ?? "dollarsign.circle" }
    set { symbol = newValue }
  }

}

// MARK: Generated accessors for expense
extension CategoryEntity {

    @objc(addExpenseObject:)
    @NSManaged public func addToExpense(_ value: ExpenseEntity)

    @objc(removeExpenseObject:)
    @NSManaged public func removeFromExpense(_ value: ExpenseEntity)

    @objc(addExpense:)
    @NSManaged public func addToExpense(_ values: NSSet)

    @objc(removeExpense:)
    @NSManaged public func removeFromExpense(_ values: NSSet)

}
