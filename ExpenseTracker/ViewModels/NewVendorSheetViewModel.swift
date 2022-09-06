//
//  NewVendorSheetViewModel.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 9/6/22.
//

import SwiftUI

class NewVendorSheetViewModel: ObservableObject {
  @Published var storedVendor: VendorModel?
  
  @Published var name = ""
  
  func makeNewVendorModel() {
    let newVendor = VendorModel(name: name)
    storedVendor = newVendor
  }
}
