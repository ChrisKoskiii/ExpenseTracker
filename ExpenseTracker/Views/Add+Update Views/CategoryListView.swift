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
  
  @State var detailExpenseCategory: CategoryEntity?
  
  var body: some View {
    List {
      ForEach(data.savedCategories, id: \.self) { item in
        let symbolColor = Color(red: item.colorR, green: item.colorG, blue: item.colorB, opacity: item.colorA)
        HStack {
          Button {
            if detailExpenseCategory == nil {
            expensesVM.newCategory(name: item.wrappedName, symbol: item.wrappedSymbol, colorR: item.colorR, colorG: item.colorG, colorB: item.colorB, colorA: item.colorA)
            } else {
              detailExpenseCategory?.name = item.name
              detailExpenseCategory?.symbol = item.symbol
              detailExpenseCategory?.colorR = item.colorR
              detailExpenseCategory?.colorG = item.colorG
              detailExpenseCategory?.colorB = item.colorB
              detailExpenseCategory?.colorA = item.colorA
            }
            presentationMode.wrappedValue.dismiss()
          } label: {
            Text(item.wrappedName)
              .foregroundColor(.primary)
          }
          .buttonStyle(.borderless)
          Spacer()
          NavigationLink(destination: CategoryPickerView(category: item)) {
            Image(systemName: item.wrappedSymbol)
              .resizable()
              .scaledToFit()
              .frame(width: 40, height: 40)
              .foregroundColor(symbolColor)
          }
          .frame(width: 60)
          .buttonStyle(PlainButtonStyle())
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
