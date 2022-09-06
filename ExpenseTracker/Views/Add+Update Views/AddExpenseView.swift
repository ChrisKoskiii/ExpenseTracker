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
  
  //  private var bindableCategoryString: Binding<String> { Binding (
  //    get: { self.expensesVM.selectedCategory?.name ?? "" },
  //    set: { _ in }
  //  )
  //  }
  
  //Move this to viewModel
  @State private var dateValue: Date = Date.now
  private var dateString: String {
    dateValue.formatDate()
  }
  
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
          DatePicker(dateValue.formatDate(), selection: $dateValue, displayedComponents: [.date])
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
            VendorListView(expensesVM: expensesVM, selectedVendor: $viewModel.selectedVendor)
          }
          
          
          Divider()
          
          CustomItemPicker(item: viewModel.categoryText) {
            CategoryListView(expensesVM: expensesVM, selectedCategory: $viewModel.selectedCategory) }
          
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
          viewModel.makeNewExpense(category: myCategory, vendor: myVendor, date: dateValue) { expense in
            coreData.addExpense(expense)
          }
        }
        presentationMode.wrappedValue.dismiss()
        //        if !expensesVM.categories.contains(expensesVM.selectedCategory!) {
        //          expensesVM.categories.append(expensesVM.selectedCategory!)
        //        }
        //        if !expensesVM.vendors.contains(expensesVM.selectedVendor!) {
        //          expensesVM.vendors.append(expensesVM.selectedVendor!)
        //        }
        expensesVM.selectedVendor = nil
        expensesVM.selectedCategory = nil
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
        expensesVM.selectedVendor == nil ||
        expensesVM.selectedCategory?.name == "" {
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
