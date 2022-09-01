//
//  ExpenseEntity+CoreDataProperties.swift
//  
//
//  Created by Christopher Koski on 8/31/22.
//
//

import Foundation
import CoreData


extension ExpenseEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExpenseEntity> {
        return NSFetchRequest<ExpenseEntity>(entityName: "ExpenseEntity")
    }

    @NSManaged public var cost: Double
    @NSManaged public var date: Date?
    @NSManaged public var receipt: Data?
    @NSManaged public var title: String?
    @NSManaged public var category: CategoryEntity
    @NSManaged public var vendor: VendorEntity
  
  var wrappedDate: Date {
    get { date ?? Date.now }
    set { date = newValue }
  }
  
  var wrappedTitle: String {
    get { title ?? "Unknown" }
    set { title = newValue }
  }

}
