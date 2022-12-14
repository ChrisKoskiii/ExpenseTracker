//
//  AddExpenseView.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 7/28/22.
//

import SwiftUI

struct AddExpenseView: View {
  @Environment(\.presentationMode) var presentationMode
  
  @EnvironmentObject var dataManager:  CoreDataManager
  @EnvironmentObject var tools:     GlobalTools
  
  @StateObject var viewModel = AddExpenseViewModel()
  
  var body: some View {
    ScrollView {
      VStack(spacing: 10) {
        VStack(spacing: 0) {
          DatePicker(viewModel.dateValue.formatDate(), selection: $viewModel.dateValue, displayedComponents: [.date])
            .textfieldStyle()
          Divider()
          TextField("Enter title", text: $viewModel.titleText)
            .textfieldStyle()
          Divider()
          TextField("$", value: $viewModel.costText, formatter: tools.myFormatter)
            .textfieldStyle()
            .keyboardType(.decimalPad)
        }
        .cardBackground()
        .padding(.horizontal)
        
        AddCustomVendorPicker(viewModel: viewModel) {
          VendorListView(selectedVendor: $viewModel.selectedVendor, vendorText: $viewModel.vendorText)
        }
        .cardBackground()
        .padding(.horizontal)
        
        AddCustomCategoryPicker(viewModel: viewModel) {
          CategoryListView(selectedCategory: $viewModel.selectedCategory, categoryText: $viewModel.categoryText, categorySymbol: $viewModel.symbol)
        }
        .cardBackground()
        .padding(.horizontal)
        
        ScanButton(showScanner: $viewModel.showScanner)
        
        addExpenseButton
        
        if viewModel.scannedImage != nil {
          scannedImageView
        }
        
        Spacer()
      }
    }
    .background(Color(.secondarySystemBackground))
    .navigationTitle("Add expense")
    .alert("Please fill out all fields.",
           isPresented: $viewModel.presentAlert,
           actions: { })
    .sheet(isPresented: $viewModel.showScanner, content: {
      ScannerView { result in
        viewModel.scanResult(result)
      } didCancelScanning: {
        viewModel.showScanner = false
      }
    })
  }
  
  var addExpenseButton: some View {
    Button {
      if viewModel.emptyTextFields() {
        viewModel.presentAlert.toggle()
      } else {
        if let myCategory = viewModel.selectedCategory,
           let myVendor = viewModel.selectedVendor {
          viewModel.makeNewExpense(category: myCategory, vendor: myVendor, date: viewModel.dateValue) { expense in
            dataManager.addExpense(expense)
          }
        }
        dataManager.fetchData()
        presentationMode.wrappedValue.dismiss()
      }
    } label: {
      Text("Add Expense")
        .addButtonStyle()
    }
  }
  
  var scannedImageView: some View {
    NavigationLink(destination: ScannedImageView(scannedImage: viewModel.scannedImage!)) {
      Image(uiImage: viewModel.scannedImage!)
        .resizable()
        .scaledToFit()
        .frame(width: 150, height: 150)
    }
  }
}


struct AddExpenseView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      AddExpenseView()
    }
    NavigationView {
      AddExpenseView()
    }
    .preferredColorScheme(.dark)
  }
}

struct AddCustomCategoryPicker<Content:View>: View {
  @ObservedObject var viewModel: AddExpenseViewModel
  
  var content: () -> Content
  
  init(viewModel: AddExpenseViewModel, @ViewBuilder content: @escaping () -> Content) {
    self.viewModel = viewModel
    self.content = content
  }
  var body: some View {
    NavigationLink(destination: content) {
      HStack {
        RecentSymbol(symbol: viewModel.symbol, color: viewModel.color ?? .black)
        Text(viewModel.categoryText)
          .font(.headline)
          .frame(maxWidth: .infinity, alignment: .leading)
          .frame(height: 55)
          .padding(.horizontal)
          .cornerRadius(10)
        Image(systemName: "chevron.right")
      }
      .foregroundColor(.recentTextColor)
      .padding(.horizontal)
    }
  }
}

struct AddCustomVendorPicker<Content:View>: View {
  @ObservedObject var viewModel: AddExpenseViewModel
  
  var content: () -> Content
  
  init(viewModel: AddExpenseViewModel, @ViewBuilder content: @escaping () -> Content) {
    self.viewModel = viewModel
    self.content = content
  }
  var body: some View {
    NavigationLink(destination: content) {
      HStack {
        Text(viewModel.vendorText)
          .font(.headline)
          .frame(maxWidth: .infinity, alignment: .leading)
          .frame(height: 55)
          .padding(.horizontal)
          .cornerRadius(10)
        Image(systemName: "chevron.right")
      }
      .foregroundColor(.recentTextColor)
      .padding(.horizontal)
    }
  }
}
