//
//  ItemList.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 8/18/22.
//

import SwiftUI

struct ItemList: View {
  @Environment(\.presentationMode) var presentationMode
  
  @State var items: [String]
  @State var selectedChoice = "Alphabetical"
  @Binding var selectedItem: String?
  
  var sortChoices = ["Alphabetical", "Recently Used"]
  var body: some View {
    List {
      ForEach(items, id: \.self) { item in
        Button {
          selectedItem = item
          presentationMode.wrappedValue.dismiss()
        } label: {
          Text(item)
        }
      }
      .onDelete(perform: deleteItem)
    }
    .listStyle(.plain)
    .background(Color(.secondarySystemBackground))
  }
  
  func deleteItem(at offsets: IndexSet) {
    items.remove(atOffsets: offsets)
    print(items)
  }
}

struct ItemList_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      ItemList(items: [
        "Professional Fees",
        "Service Fees",
        "Equipment",
        "Uniforms",
        "Licenses"
      ], selectedItem: .constant("Constant"))
    }
  }
}
