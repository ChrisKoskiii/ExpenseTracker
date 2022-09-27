////
////  CategoryPickerView.swift
////  ExpenseTracker
////
////  Created by Christopher Koski on 8/31/22.
////
//
//import SwiftUI
//
//struct EditCategorySheet: View {
//  @EnvironmentObject var dataManager: CoreDataManager
//  @EnvironmentObject var global:      GlobalTools
//
//  @StateObject var viewModel = EditCategorySheetViewModel()
//
//  @Binding var category: CategoryEntity
//
//  @Binding var isPresented: Bool
//
//  let columns = [
//    GridItem(.adaptive(minimum: 40))
//  ]
//
//  var body: some View {
//    VStack {
//
//      categoryToCreate
//
//      ColorPicker("Set the symbol color", selection: $viewModel.symbolColor)
//        .padding()
//
//      symbolsGrid
//
//      Button {
//        updateCategory()
//      } label: {
//        Text("Update Category")
//          .addButtonStyle()
//      }
//    }
//    .background(Color(.secondarySystemBackground))
//    .onAppear {
//      viewModel.updateStoredCategory(with: category)
//    }
//  }
//
//  func updateCategory() {
//    if let storedCategory = viewModel.storedCategory {
//      dataManager.updateCategory(category, with: storedCategory)
//      print("🎉🎉🎉🎉🎉🎉🎉 Updated")
//      dataManager.fetchCategories()
//      isPresented = false
//    }
//  }
//
//  var categoryToCreate: some View {
//    HStack {
//
//      TextField("Category name", text: $viewModel.name)
//        .textfieldStyle()
//      Image(systemName: viewModel.symbol)
//        .resizable()
//        .scaledToFit()
//        .frame(width: 30, height: 30)
//        .foregroundColor(viewModel.symbolColor)
//        .padding(.trailing)
//    }
//    .cardBackground()
//    .padding()
//  }
//
//  var symbolsGrid: some View {
//    ScrollView {
//      LazyVGrid(columns: columns, spacing: 20) {
//        ForEach(0..<global.symbolsArray.count, id: \.self) { symbol in
//          Button {
//            viewModel.symbol = global.symbolsArray[symbol]
//          } label: {
//            Image(systemName: global.symbolsArray[symbol])
//              .resizable()
//              .scaledToFit()
//              .frame(width: 30, height: 30)
//              .foregroundColor(viewModel.symbolColor)
//          }
//        }
//      }
//    }
//    .padding()
//  }
//}
//
//struct EditCategorySheet_Previews: PreviewProvider {
//  static var previews: some View {
//    NewCategorySheet(isPresented: .constant(true))
//      .environmentObject(CoreDataManager())
//  }
//
//}
