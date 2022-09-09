//
//  DetailExpenseView.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 7/30/22.
//

import SwiftUI

struct DetailExpenseView: View {
  @Environment(\.presentationMode) var presentationMode
  
  @EnvironmentObject var tools: GlobalTools
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
  @State private var hasLoadedBefore    = false
  private var dateString: String {
    detailExpense.wrappedDate.formatDate()
  }
  
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
    .task {
      if !hasLoadedBefore {
      await viewModel.getDetails(from: detailExpense)
        hasLoadedBefore = true
      }
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
    VStack(spacing: 10) {
      VStack {
        DatePicker(dateString, selection: $viewModel.date, displayedComponents: [.date])
          .textfieldStyle()
        Divider()
        TextField("Enter title", text: $viewModel.title)
          .textfieldStyle()
        Divider()
        TextField("Enter cost", value: $viewModel.cost, formatter: tools.myFormatter)
          .textfieldStyle()
          .keyboardType(.decimalPad)
      }
      DetailCustomVendorPicker(viewModel: viewModel) {
        VendorListView(selectedVendor: $viewModel.selectedVendor, vendorText: $viewModel.vendorName)
      }
      .cardBackground()
      .padding(.horizontal)
      
      DetailCustomCategoryPicker(viewModel: viewModel) {
        CategoryListView(selectedCategory: $viewModel.selectedCategory, categoryText: $viewModel.categoryName)
      }
      .cardBackground()
      .padding(.horizontal)
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

struct DetailCustomCategoryPicker<Content:View>: View {
  @ObservedObject var viewModel: DetailExpenseViewModel
  
  var content: () -> Content
  
  init(viewModel: DetailExpenseViewModel, @ViewBuilder content: @escaping () -> Content) {
    self.viewModel = viewModel
    self.content = content
  }
  var body: some View {
    NavigationLink(destination: content) {
      HStack {
        RecentSymbol(symbol: viewModel.categorySymbol, color: viewModel.color)
        Text(viewModel.categoryName)
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

struct DetailCustomVendorPicker<Content:View>: View {
  @ObservedObject var viewModel: DetailExpenseViewModel
  
  var content: () -> Content
  
  init(viewModel: DetailExpenseViewModel, @ViewBuilder content: @escaping () -> Content) {
    self.viewModel = viewModel
    self.content = content
  }
  var body: some View {
    NavigationLink(destination: content) {
      HStack {
        Text(viewModel.vendorName)
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
