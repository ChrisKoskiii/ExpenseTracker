//
//  CategoryListView.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 8/18/22.
//

import SwiftUI

struct CategoryListView: View {
  @Environment(\.presentationMode) var presentationMode
  
  @EnvironmentObject var data:    CoreDataManager
  @ObservedObject var expensesVM:   ExpensesViewModel
  
  @State var detailExpenseCategory: String?
  
  var body: some View {
    List {
      ForEach(data.savedCategories, id: \.self) { item in
        Button {
          expensesVM.selectedCategory = item.name
          presentationMode.wrappedValue.dismiss()
        } label: {
          Text(item.wrappedName)
        }
      }
    }
    .listStyle(.plain)
    .background(Color(.secondarySystemBackground))
    .navigationTitle("Categories")
    .navigationBarTitleDisplayMode(.inline)
  }
  
  //Getting fatal error when deleting from list
//  func deleteItem(at offsets: IndexSet) {
//    for index in offsets {
//      let item = data.savedCategories[index]
//      data.deleteCategory(item)
//    }
//  }
  
}

struct CategoryListView_Previews: PreviewProvider {
  
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
