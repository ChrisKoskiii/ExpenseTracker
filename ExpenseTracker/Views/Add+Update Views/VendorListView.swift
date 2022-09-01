//
//  VendorListView.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 8/18/22.
//

import SwiftUI

struct VendorListView: View {
  @Environment(\.presentationMode) var presentationMode
  
  @EnvironmentObject var data:  CoreDataManager
  @ObservedObject var expensesVM: ExpensesViewModel
  
  var body: some View {
    List {
      ForEach(data.savedVendors, id: \.self) { item in
        Button {
          expensesVM.selectedVendor = item.name
//          presentationMode.wrappedValue.dismiss()
        } label: {
          Text(item.wrappedName)
        }
      }
    }
    .listStyle(.plain)
    .background(Color(.secondarySystemBackground))
    .navigationTitle("Vendors")
    .navigationBarTitleDisplayMode(.inline)
  }
  // Getting fatal error when deleting from list
//  func deleteItem(at offsets: IndexSet) {
//    for index in offsets {
//      let item = data.savedVendors[index]
//      data.deleteVendor(item)
//    }
//  }
  
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
