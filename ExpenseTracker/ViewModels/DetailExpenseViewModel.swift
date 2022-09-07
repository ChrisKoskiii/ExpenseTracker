//
//  DetailExpenseViewModel.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 9/6/22.
//

import SwiftUI

class DetailExpenseViewModel: ObservableObject {
  @Published var selectedCategory: CategoryModel?
  @Published var selectedVendor: VendorModel?
  
}
