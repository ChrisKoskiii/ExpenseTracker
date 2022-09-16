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
  
  @Binding var selectedVendor: VendorModel?
  @Binding var vendorText: String
  
  @State private var showingSheet = false
  
  var body: some View {
    List {
      Button("Add new") {
        showingSheet.toggle()
      }
      ForEach(data.savedVendors, id: \.self) { item in
        Button {
          selectedVendor = vendorEntityToModel(item)
          vendorText = item.wrappedName
          presentationMode.wrappedValue.dismiss()
        } label: {
          Text(item.wrappedName)
        }
      }
      .onDelete(perform: deleteItem)
    }
    .listStyle(.plain)
    .background(Color(.secondarySystemBackground))
    .navigationTitle("Vendors")
    .navigationBarTitleDisplayMode(.inline)
    .sheet(isPresented: $showingSheet, onDismiss: {
      data.fetchVendors() 
    }) {
      NewVendorSheet(isPresented: $showingSheet)
    }
  }

  func deleteItem(at offsets: IndexSet) {
    for index in offsets {
      let item = data.savedVendors[index]
      data.deleteEntity(item)
      data.savedVendors.remove(at: index)
    }
  }
  
  func vendorEntityToModel(_ vendor: VendorEntity) -> VendorModel {
    return VendorModel(name: vendor.wrappedName)
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
