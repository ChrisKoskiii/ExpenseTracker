//
//  CategoryEntity+Ext.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 9/27/22.
//

import SwiftUI

extension CategoryEntity {
  func computeColor() -> Color {
    return Color.clear.getColor(from: self)
  }
}
