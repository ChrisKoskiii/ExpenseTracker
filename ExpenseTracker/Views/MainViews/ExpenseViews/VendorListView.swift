//
//  VendorListView.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 8/18/22.
//

import SwiftUI

struct VendorListView: View {
  @Environment(\.presentationMode) var presentationMode
  
  @EnvironmentObject var coreVM: CoreDataViewModel
  
  @ObservedObject var expensesVM: ExpensesViewModel
  
  var body: some View {
    List {
      ForEach(expensesVM.vendors, id: \.self) { item in
        Button {
          expensesVM.selectedVendor = item
//          presentationMode.wrappedValue.dismiss()
        } label: {
          Text(item)
        }
      }
      .onDelete(perform: deleteItem)
    }
    .listStyle(.plain)
    .background(Color(.secondarySystemBackground))
    .navigationTitle("Vendors")
    .navigationBarTitleDisplayMode(.inline)
  }
  
  func deleteItem(at offsets: IndexSet) {
    expensesVM.vendors.remove(atOffsets: offsets)
  }
  
}

struct VendorListView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      ItemList(items: [
        "Home-Depot",
        "Mr. Tax Man",
        "Ace Hardware",
        "EquipmentAndStuff.com",
        "Palm Beach County"
      ], selectedItem: .constant("Constant"))
    }
  }
}
