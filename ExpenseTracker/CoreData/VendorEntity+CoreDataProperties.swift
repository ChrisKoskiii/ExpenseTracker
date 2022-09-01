//
//  VendorEntity+CoreDataProperties.swift
//  
//
//  Created by Christopher Koski on 8/31/22.
//
//

import Foundation
import CoreData


extension VendorEntity {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<VendorEntity> {
    return NSFetchRequest<VendorEntity>(entityName: "VendorEntity")
  }
  
  @NSManaged public var name: String?
  @NSManaged public var expense: ExpenseEntity?
  
  var wrappedName: String {
    get { name ?? "Unkown"}
    set { name = newValue }
  }
}
