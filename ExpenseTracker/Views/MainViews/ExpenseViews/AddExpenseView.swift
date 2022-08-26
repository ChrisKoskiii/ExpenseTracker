//
//  AddExpenseView.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 7/28/22.
//

import SwiftUI

struct AddExpenseView: View {
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var coreVM: CoreDataViewModel
  //ViewModels
  @ObservedObject var expensesVM: ExpensesViewModel
  
  //Scanner state
  @State private var cameraIsPresented = false
  @State private var showScanner = false
  @State private var isRecognizing = false
  
  @State private var presentAlert = false
  
  //Form inputs
  @State private var titleText: String = ""
  @State private var costText = 0.00
  @State private var dateValue: Date = Date.now
  
  private var dateString: String {
    dateValue.formatDate()
  }
  
  //Scanned image vars
  @State private var imageData: Data?
  @State private var scannedImage: UIImage?
  
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
        DatePicker(dateValue.formatDate(), selection: $dateValue, displayedComponents: [.date])
          .textfieldStyle()
        TextField("Enter title", text: $titleText)
          .textfieldStyle()
        
        TextField("$", value: $costText, formatter: formatter)
          .textfieldStyle()
          .keyboardType(.decimalPad)
        
        ZStack {
          TextField("Enter vendor", text: $expensesVM.selectedVendor ?? "")
            .textfieldStyle()
          HStack {
            Spacer()
            NavigationLink(destination: VendorListView(expensesVM: expensesVM)) {
              Image(systemName: "chevron.right")}
            .frame(width: 20)
            .padding(.trailing, 20)
          }
        }
        
        ZStack {
          TextField("Enter category", text: $expensesVM.selectedCategory ?? "")
            .textfieldStyle()
          HStack {
            Spacer()
            NavigationLink(destination: CategoryListView(expensesVM: expensesVM)) {
              Image(systemName: "chevron.right")
            }
            .frame(width: 20)
            .padding(.trailing, 20)
          }
        }
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
          imageData = coreVM.getImageData(scannedImage!)
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
        expensesVM.makeNewExpense(category: expensesVM.selectedCategory!,
                                  cost: costText,
                                  date: dateValue,
                                  title: titleText,
                                  vendor: expensesVM.selectedVendor!,
                                  receipt: imageData
        ) { expense in
          coreVM.addExpense(expense)
        }
        presentationMode.wrappedValue.dismiss()
        coreVM.getDateRangeExpenses(
          startDate: expensesVM.monthStart,
          endDate: expensesVM.monthEnd) { expenses in
            expensesVM.dateRangeExpenses = expenses
          }
        if !expensesVM.categories.contains(expensesVM.selectedCategory!) {
          expensesVM.categories.append(expensesVM.selectedCategory!)
        }
        if !expensesVM.vendors.contains(expensesVM.selectedVendor!) {
          expensesVM.vendors.append(expensesVM.selectedVendor!)
        }
        expensesVM.selectedVendor = nil
        expensesVM.selectedCategory = nil
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
        expensesVM.selectedCategory == nil {
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
