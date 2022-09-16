//
//  NewVendorSheet.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 9/6/22.
//

import SwiftUI

struct NewVendorSheet: View {
  @EnvironmentObject var data: CoreDataManager
  
  @StateObject var viewModel = NewVendorSheetViewModel()
  
  @Binding var isPresented: Bool
  
  @State private var showExistingAlert = false
  
    var body: some View {
      VStack {
      TextField("Vendor Name", text: $viewModel.name)
        Button("Add Vendor") {
          viewModel.makeNewVendorModel()
          if let vendor = viewModel.storedVendor {
            let result = data.isDuplicate(vendor.name, "VendorEntity")
            if result.isTrue {
              showExistingAlert = true
            } else {
              data.addVendor(vendor)
              viewModel.storedVendor = nil
              isPresented = false
            }
          }
        }
      }
      .alert("Category already exists", isPresented: $showExistingAlert) { }
    }
}

struct NewVendorSheet_Previews: PreviewProvider {
    static var previews: some View {
      NewVendorSheet(isPresented: .constant(true))
    }
}
