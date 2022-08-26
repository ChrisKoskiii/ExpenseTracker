//
//  CategoryListView.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 8/18/22.
//

import SwiftUI

struct CategoryListView: View {
  @Environment(\.presentationMode) var presentationMode
  
  @EnvironmentObject var coreVM: CoreDataViewModel
  
  @ObservedObject var expensesVM: ExpensesViewModel
  
  @State var detailExpenseCategory: String?
  
  var body: some View {
    List {
      ForEach(expensesVM.categories, id: \.self) { item in
        Button {
          expensesVM.selectedCategory = item
          presentationMode.wrappedValue.dismiss()
        } label: {
          Text(item)
        }
      }
      .onDelete(perform: deleteItem)
    }
    .listStyle(.plain)
    .background(Color(.secondarySystemBackground))
    .navigationTitle("Categories")
    .navigationBarTitleDisplayMode(.inline)
  }
  
  func deleteItem(at offsets: IndexSet) {
    expensesVM.categories.remove(atOffsets: offsets)
  }
  
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
