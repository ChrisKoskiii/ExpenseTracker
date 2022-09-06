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
  
  //Scanner state
  @State private var cameraIsPresented  = false
  @State private var showScanner        = false
  @State private var isRecognizing      = false
  
  //Alert
  @State private var presentAlert       = false
  
  //Form inputs
  @State private var titleText: String    = ""
  @State private var costText             = 0.00
  @State private var dateValue: Date      = Date.now
  @State private var categoryText: String = "Select Category"
  @State private var vendorText: String   = "Select Vendor"
  private var dateString: String {
    dateValue.formatDate()
  }
  
  //Scanned image vars
  @State private var imageData: Data?
  @State private var scannedImage: UIImage?
  
  private var bindableCategoryString: Binding<String> { Binding (
    get: { self.expensesVM.selectedCategory?.name ?? "" },
    set: { _ in }
  )
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
          TextField("Enter title", text: $titleText)
            .textfieldStyle()
          Divider()
          TextField("$", value: $costText, formatter: formatter)
            .textfieldStyle()
            .keyboardType(.decimalPad)
          Divider()
          
          CustomItemPicker(item: vendorText) {
            VendorListView(expensesVM: expensesVM)
          }
          
          
          Divider()
          
          CustomItemPicker(item: categoryText) {
            CategoryListView(expensesVM: expensesVM) }
          
        }
        .cardBackground()
        .padding(.horizontal)
        scanButton
        
        addExpenseButton
        
        if scannedImage != nil {
          scannedImageView
        }
        
        Spacer()
      }
    }
    .background(Color(.secondarySystemBackground))
    .navigationTitle("Add expense")
    .alert("Please fill out all fields.", isPresented: $presentAlert, actions: {
    })
    .sheet(isPresented: $showScanner, content: {
      ScannerView { result in
        switch result {
        case .success(let scannedImages):
          isRecognizing = true
          scannedImage = scannedImages.first!
          imageData = coreData.getImageData(scannedImage!)
        case .failure(let error):
          print(error.localizedDescription)
        }
        
        showScanner = false
        
      } didCancelScanning: {
        // Dismiss the scanner controller and the sheet.
        showScanner = false
      }
    })
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
  
  var addExpenseButton: some View {
    Button {
      if emptyTextFields() {
        presentAlert.toggle()
      } else {
        expensesVM.makeNewExpense(category: expensesVM.selectedCategory?.name ?? "Unknown",
                                  cost: costText,
                                  date: dateValue,
                                  title: titleText,
                                  vendor: expensesVM.selectedVendor!,
                                  receipt: imageData,
                                  symbol: expensesVM.selectedCategory?.symbol ?? "dollarsign.circle",
                                  colorR: expensesVM.selectedCategory?.colorR ?? 0.0,
                                  colorG: expensesVM.selectedCategory?.colorG ?? 0.0,
                                  colorB: expensesVM.selectedCategory?.colorB ?? 0.0,
                                  colorA: expensesVM.selectedCategory?.colorA ?? 0.0
        ) { expense in
          coreData.addExpense(expense)
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
    NavigationLink(destination: ScannedImageView(scannedImage: scannedImage!)) {
      Image(uiImage: scannedImage!)
        .resizable()
        .scaledToFit()
        .frame(width: 150, height: 150)
    }
  }
  
  func emptyTextFields() -> Bool {
    if titleText.isEmpty ||
        costText.isZero ||
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
