//
//  DetailExpenseView.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 7/30/22.
//

import SwiftUI

struct DetailExpenseView: View {
  @Environment(\.presentationMode) var presentationMode
  
  @EnvironmentObject var coreVM:  CoreDataManager
  @ObservedObject var expensesVM: ExpensesViewModel
  @StateObject var viewModel = DetailExpenseViewModel()
  
  @State var detailExpense:       ExpenseEntity
  
  //Scanner properties
  @State private var cameraIsPresented  = false
  @State private var showScanner        = false
  @State private var isRecognizing      = false
  @State private var scannedImage:      UIImage?
  
  //Alert
  @State private var showingAlert       = false
  
  private var dateString: String {
    detailExpense.wrappedDate.formatDate()
  }
  
  
  //Current textfield formatter
  var formatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    return formatter
  }()
  
  var body: some View {
    ScrollView {
      VStack(spacing: 10) {
        
        expenseTextfields

        scanButton
        
        updateExpenseButton
        
        if scannedImage != nil {
          scannedImageView
        }
        
        Spacer()
      }
    }
    .background(Color(.secondarySystemBackground))
    .navigationTitle("Update expense")
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem {
        Button {
          showingAlert.toggle()
        } label: {
          Image(systemName: "trash")
            .foregroundColor(.red)
        }
      }
    }
    .sheet(isPresented: $showScanner, content: {
      ScannerView { result in
        switch result {
        case .success(let scannedImages):
          isRecognizing = true
          scannedImage = scannedImages.first
          detailExpense.receipt = coreVM.getImageData(scannedImage!)
        case .failure(let error):
          print(error.localizedDescription)
        }
        showScanner = false
      } didCancelScanning: {
        showScanner = false
      }
    })
    .task {
      await convertData()
    }
    .alert("Are you sure you want to delete this expense?", isPresented: $showingAlert) {
      Button("Delete", role: .destructive) {
        presentationMode.wrappedValue.dismiss()
        coreVM.deleteExpense(detailExpense)
      }
      .foregroundColor(.red)
      Button("Cancel", role: .cancel) { }
    }
  }
  
  var expenseTextfields: some View {
    VStack(spacing: 0) {
      DatePicker(dateString, selection: $detailExpense.wrappedDate, displayedComponents: [.date])
        .textfieldStyle()
      Divider()
      TextField("Enter title", text: $detailExpense.wrappedTitle)
        .textfieldStyle()
      Divider()
      TextField("Enter cost", value: $detailExpense.cost, formatter: formatter)
        .textfieldStyle()
        .keyboardType(.decimalPad)
      Divider()
      ZStack {
        TextField("Enter vendor", text: $detailExpense.vendor.wrappedName)
          .textfieldStyle()
        HStack {
          Spacer()
          NavigationLink(destination: VendorListView(selectedVendor: $viewModel.selectedVendor, vendorText: $detailExpense.vendor.wrappedName)) {
            Image(systemName: detailExpense.category.wrappedSymbol)}
          .frame(width: 20)
          .padding(.trailing, 20)
        }
      }
      Divider()
      ZStack {
        TextField("Enter category", text: $detailExpense.category.wrappedName)
          .textfieldStyle()
        HStack {
          Spacer()
          NavigationLink(destination: CategoryListView(selectedCategory: $viewModel.selectedCategory, categoryText: $detailExpense.category.wrappedName)) {
            HStack {
              Image(systemName: detailExpense.category.wrappedSymbol)
                .foregroundColor(coreVM.categoryColor(for: detailExpense.category))
              Image(systemName: "chevron.right")
            }
          }
          .frame(width: 20)
          .padding(.trailing, 20)
        }
      }
    }
    .cardBackground()
    .padding(.horizontal)
  }
  
  var scanButton: some View {
    Button {
      showScanner = true
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
  
  var updateExpenseButton: some View {
    Button {
      expensesVM.makeNewExpense(category: detailExpense.category.wrappedName,
                                cost: detailExpense.cost,
                                date: detailExpense.wrappedDate,
                                title: detailExpense.wrappedTitle,
                                vendor: detailExpense.vendor.wrappedName,
                                receipt: detailExpense.receipt,
                                symbol: detailExpense.category.wrappedSymbol,
                                colorR: detailExpense.category.colorR,
                                colorG: detailExpense.category.colorG,
                                colorB: detailExpense.category.colorB,
                                colorA: detailExpense.category.colorA
      ) { expense in
        coreVM.updateExpense(detailExpense, with: expense)
      }
//      if !expensesVM.categories.contains(expensesVM.selectedCategory!) {
//        expensesVM.categories.append(expensesVM.selectedCategory!)
//      }
//      if !expensesVM.vendors.contains(expensesVM.selectedVendor!) {
//        expensesVM.vendors.append(expensesVM.selectedVendor!)
//      }
      expensesVM.selectedCategory = nil
      expensesVM.selectedVendor = nil
        presentationMode.wrappedValue.dismiss()
    } label: {
      Text("Update Expense")
        .addButtonStyle()
    }
  }
  
  var deleteButton: some View {
    Button {
      coreVM.deleteExpense(detailExpense)
      presentationMode.wrappedValue.dismiss()
    } label: {
      Text("Delete Expense")
        .deleteButtonStyle()
      
    }
  }
  
  var scannedImageView: some View {
    NavigationLink(destination: ScannedImageView(scannedImage: scannedImage!)) {
      Image(uiImage: scannedImage!)
        .resizable()
        .scaledToFit()
        .frame(width: 150, height: 150)
    }
  }
  
  func convertData() async -> () {
    guard let imageData = detailExpense.receipt else {
      return
    }
    guard let convertedImage = UIImage(data: imageData) else { return }
    scannedImage = convertedImage
  }
  
  func emptyTextFields() -> Bool {
    if detailExpense.wrappedTitle.isEmpty ||
        detailExpense.cost == 0.00 ||
        detailExpense.vendor.wrappedName.isEmpty ||
        detailExpense.category.wrappedName.isEmpty {
      return true
    } else { return false
    }
  }
}


//struct DetailExpenseView_Previews: PreviewProvider {
//  static var previews: some View {
//    NavigationView {
//      DetailExpenseView(vm: CoreDataViewModel())
//    }
//    NavigationView {
//      DetailExpenseView(vm: CoreDataViewModel())
//    }
//    .preferredColorScheme(.dark)
//  }
//}
