////
////  EditCategorySheet.swift
////  ExpenseTracker
////
////  Created by Christopher Koski on 9/26/22.
////
//
//import SwiftUI
//
//struct EditCategorySheet: View {
//    var body: some View {
//      VStack {
//        
//        categoryToCreate
//        
//        ColorPicker("Set the symbol color", selection: $viewModel.symbolColor)
//          .padding()
//        
//        symbolsGrid
//        
//        Button {
//          createCategory()
//        } label: {
//          Text("Add Category")
//            .addButtonStyle()
//        }
//      }
//      .background(Color(.secondarySystemBackground))
//      .alert("Category already exists", isPresented: $viewModel.showExistingAlert) { }
//    }
//}
//
//struct EditCategorySheet_Previews: PreviewProvider {
//    static var previews: some View {
//        EditCategorySheet()
//    }
//}
