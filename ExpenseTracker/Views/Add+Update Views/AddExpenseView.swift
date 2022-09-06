//
//  AddExpenseView.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 7/28/22.
//

import SwiftUI

struct AddExpenseView: View {
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var coreData:  CoreDataManager
  @ObservedObject var expensesVM: ExpensesViewModel
  @StateObject var viewModel = AddExpenseViewModel()
  
  //Currency textfield formatter
  var formatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.maximumFractionDigits = 2
    return formatter
  }()
  
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
          TextField("$", value: $viewModel.costText, formatter: formatter)
            .textfieldStyle()
            .keyboardType(.decimalPad)
          Divider()
          
          CustomItemPicker(item: viewModel.vendorText) {
            VendorListView(selectedVendor: $viewModel.selectedVendor, vendorText: $viewModel.vendorText)
          }
          
          
          Divider()
          
          CustomItemPicker(item: viewModel.categoryText) {
            CategoryListView(selectedCategory: $viewModel.selectedCategory, categoryText: $viewModel.categoryText) }
          
        }
        .cardBackground()
        .padding(.horizontal)
        
        scanButton
        
        addExpenseButton
        
        if viewModel.scannedImage != nil {
          scannedImageView
        }
        
        Spacer()
      }
    }
    .background(Color(.secondarySystemBackground))
    .navigationTitle("Add expense")
    .alert("Please fill out all fields.", isPresented: $viewModel.presentAlert, actions: {
    })
    .sheet(isPresented: $viewModel.showScanner, content: {
      ScannerView { result in
        switch result {
        case .success(let scannedImages):
          viewModel.isRecognizing = true
          viewModel.scannedImage = scannedImages.first!
          viewModel.imageData = coreData.getImageData(viewModel.scannedImage!)
        case .failure(let error):
          print(error.localizedDescription)
        }
        
        viewModel.showScanner = false
        
      } didCancelScanning: {
        // Dismiss the scanner controller and the sheet.
        viewModel.showScanner = false
      }
    })
  }
  
  var scanButton: some View {
    Button {
      viewModel.showScanner = true
    } label: {
      HStack {
        Image(systemName: "doc.text.viewfinder")
          .renderingMode(.template)
          .foregroundColor(.white)
        Text("Scan")
          .foregroundColor(.white)
      }
      .scanButtonStyle()
    }
  }
  
  var addExpenseButton: some View {
    Button {
      if emptyTextFields() {
        viewModel.presentAlert.toggle()
      } else {
        if let myCategory = viewModel.selectedCategory,
           let myVendor = viewModel.selectedVendor {
          viewModel.makeNewExpense(category: myCategory, vendor: myVendor, date: viewModel.dateValue) { expense in
            coreData.addExpense(expense)
          }
        }
        presentationMode.wrappedValue.dismiss()
        coreData.fetchData()
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
  
  func emptyTextFields() -> Bool {
    if viewModel.titleText.isEmpty ||
        viewModel.costText.isZero ||
        viewModel.selectedCategory == nil ||
        viewModel.selectedVendor == nil {
      return true
    } else { return false
    }
  }
}


struct AddExpenseView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      AddExpenseView(expensesVM: ExpensesViewModel())
    }
    NavigationView {
      AddExpenseView(expensesVM: ExpensesViewModel())
    }
    .preferredColorScheme(.dark)
  }
}

struct CustomItemPicker<Content:View>: View {
  var item: String
  var content: () -> Content
  
  init(item: String, @ViewBuilder content: @escaping () -> Content) {
    self.item = item
    self.content = content
  }
  var body: some View {
    NavigationLink(destination: content) {
      HStack {
        Text(item)
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
