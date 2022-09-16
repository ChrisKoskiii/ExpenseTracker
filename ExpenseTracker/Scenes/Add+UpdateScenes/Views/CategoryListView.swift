//
//  CategoryListView.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 8/18/22.
//

import SwiftUI

struct CategoryListView: View {
  @Environment(\.presentationMode) var presentationMode
  
  @EnvironmentObject var dataManager:    CoreDataManager
  
  @Binding var selectedCategory: CategoryModel?
  @Binding var categoryText: String
  @Binding var categorySymbol: String
  
  @State private var showingSheet = false
  
  var body: some View {
    List {
      Button("Add new") {
        showingSheet.toggle()
      }
      ForEach(dataManager.savedCategories, id: \.self) { item in
        let symbolColor = Color(red: item.colorR, green: item.colorG, blue: item.colorB, opacity: item.colorA)
        HStack {
          Button {
            selectedCategory = categoryEntityToModel(item)
            categoryText = item.wrappedName
            categorySymbol = item.wrappedSymbol
            
            presentationMode.wrappedValue.dismiss()
          } label: {
            Text(item.wrappedName)
              .foregroundColor(.primary)
          }
          .buttonStyle(.borderless)
          Spacer()
          NavigationLink(destination: NewCategorySheet(isPresented: $showingSheet)) {
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
      NewCategorySheet(isPresented: $showingSheet)
    }
  }
  
  func deleteItem(at offsets: IndexSet) {
    for index in offsets {
      let item = dataManager.savedCategories[index]
      dataManager.deleteCategory(item)
      dataManager.savedCategories.remove(at: index)
    }
  }
  
  func categoryEntityToModel(_ category: CategoryEntity) -> CategoryModel {
    return CategoryModel(name: category.wrappedName, symbol: category.wrappedSymbol, colorR: category.colorR, colorG: category.colorG, colorB: category.colorB, colorA: category.colorA)

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
