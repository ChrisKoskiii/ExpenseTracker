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
  @ObservedObject var expensesVM: ExpensesViewModel
  
  @Binding var selectedCategory: CategoryModel?
  
  @State private var showingSheet = false
  
  var body: some View {
    List {
      Button("Add new") {
        showingSheet.toggle()
      }
      ForEach(data.savedCategories, id: \.self) { item in
        let symbolColor = Color(red: item.colorR, green: item.colorG, blue: item.colorB, opacity: item.colorA)
        HStack {
          Button {
            selectedCategory = expensesVM.categoryEntityToModel(item)
            presentationMode.wrappedValue.dismiss()
          } label: {
            Text(item.wrappedName)
              .foregroundColor(.primary)
          }
          .buttonStyle(.borderless)
          Spacer()
          NavigationLink(destination: NewCategorySheet()) {
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
      .onDelete(perform: deleteItem)
    }
    .listStyle(.plain)
    .background(Color(.secondarySystemBackground))
    .navigationTitle("Categories")
    .navigationBarTitleDisplayMode(.inline)
    .sheet(isPresented: $showingSheet) {
      NewCategorySheet()
    }
  }
  
  func deleteItem(at offsets: IndexSet) {
    for index in offsets {
      let item = data.savedCategories[index]
      data.deleteCategory(item)
      data.savedCategories.remove(at: index)
    }
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
