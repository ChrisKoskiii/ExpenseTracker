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
  
    var body: some View {
      VStack {
      TextField("Vendor Name", text: $viewModel.name)
        Button("Add Vendor") {
          viewModel.makeNewVendorModel()
          if let vendor = viewModel.storedVendor {
            data.addVendor(vendor)
            viewModel.storedVendor = nil
            isPresented = false
          }
        }
      }
    }
}

struct NewVendorSheet_Previews: PreviewProvider {
    static var previews: some View {
      NewVendorSheet(isPresented: .constant(true))
    }
}
