//
//  CategoryPickerView.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 8/31/22.
//

import SwiftUI

struct NewCategorySheet: View {
  @EnvironmentObject var data: CoreDataManager
  
  @StateObject var viewModel = NewCategorySheetViewModel()
  
  @Binding var isPresented: Bool
  
  let columns = [
    GridItem(.adaptive(minimum: 40))
  ]
  
  var body: some View {
    VStack {
      
      categoryToCreate
      
      ColorPicker("Set the symbol color", selection: $viewModel.symbolColor)
        .padding()
      
      symbolsGrid
      
      Button {
        createCategory()
      } label: {
        Text("Add Category")
          .addButtonStyle()
      }
    }
    .background(Color(.secondarySystemBackground))
    .alert("Category already exists", isPresented: $viewModel.showExistingAlert) { }
  }
  
  func createCategory() {
    viewModel.makeCategoryModel()
    if let category = viewModel.storedCategory {
      let result = data.isDuplicate(category.name, "CategoryEntity")
      if result.isTrue {
        viewModel.showExistingAlert = true
      } else {
        data.addCategory(category)
        viewModel.storedCategory = nil
        data.fetchCategories()
        isPresented = false
      }
    }
  }
  
  var categoryToCreate: some View {
    HStack {
      
      TextField("Category name", text: $viewModel.name)
        .textfieldStyle()
      Image(systemName: viewModel.symbol)
        .resizable()
        .scaledToFit()
        .frame(width: 30, height: 30)
        .foregroundColor(viewModel.symbolColor)
        .padding(.trailing)
    }
    .cardBackground()
    .padding()
  }
  
  var symbolsGrid: some View {
    ScrollView {
      LazyVGrid(columns: columns, spacing: 20) {
        ForEach(0..<viewModel.symbolsArray.count, id: \.self) { symbol in
          Button {
            viewModel.symbol = viewModel.symbolsArray[symbol]
          } label: {
            Image(systemName: viewModel.symbolsArray[symbol])
              .resizable()
              .scaledToFit()
              .frame(width: 30, height: 30)
              .foregroundColor(viewModel.symbolColor)
          }
        }
      }
    }
    .padding()
  }
}

struct NewCategorySheet_Previews: PreviewProvider {
  static var previews: some View {
    NewCategorySheet(isPresented: .constant(true))
      .environmentObject(CoreDataManager())
  }
  
}
