//
//  ReportsView.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 7/29/22.
//

import SwiftUI

struct ReportsView: View {
  
  @EnvironmentObject var coreVM:  CoreDataManager
  @EnvironmentObject var tools:   GlobalTools
  
  @StateObject var viewModel = ReportsViewModel()
  
  @Binding var startDate: Date
  @Binding var endDate:   Date
  
  var body: some View {
    
    expenseList
      .navigationBarTitle("Generate Reports")
      .navigationBarTitleDisplayMode(.inline)
      .background(Color(uiColor: .systemGray5))
      .toolbar {
        ToolbarItem {
          
          Button {
            exportToPDF()
          } label : {
            Image(systemName: "square.and.arrow.up.fill")
          }
        }
      }
    
      .sheet(isPresented: $viewModel.showShareSheet) {
        viewModel.PDFUrl = nil
      } content: {
        if let PDFUrl = viewModel.PDFUrl {
          ShareSheet(urls: [PDFUrl])
        }
      }
    
      .onAppear {
        coreVM.fetchDateRangeExpenses(startDate: startDate, endDate: endDate)
        viewModel.getTotal(from: coreVM.dateRangeExpenses)
      }
      .onDisappear {
        coreVM.categoriesDict.keys.forEach { coreVM.categoriesDict[$0] = 0.0}
      }
  }
  
  var expenseList: some View {
    VStack {
      HStack {
        
        Text("\(startDate.formatDateForReport()) to \(endDate.formatDateForReport())")
          .font(.title2)
          .padding()
        
        Spacer()
        
      }
      
      let categories = coreVM.categoriesDict.keys.sorted().map{Category(name: $0, cost: coreVM.categoriesDict[$0]!)}
      
      ForEach(categories, id: \.name) { category in
        HStack {
          
          Text(category.name)
            .font(.caption)
            .padding(.leading )
            .lineLimit(0)
          
          Spacer()
          
          let costString = tools.myFormatter.string(from: NSNumber(value: category.cost))!
          
          Text(costString)
            .font(.caption)
            .padding(.trailing)
        }
        Divider()
      }
      HStack {
        
        Text("Total:")
          .padding(.leading )
        
        Spacer()
        
        Text("$"+String(format: "%.2f", viewModel.total))
          .padding(.trailing)
        
      }
      Spacer()
    }
  }
  
  func exportToPDF() {
    
    let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let outputFileURL = documentDirectory.appendingPathComponent("SwiftUI.pdf")
    
    //Normal with
    let width: CGFloat  = 8.5 * 72.0
    //Estimate the height of your view
    let height: CGFloat = 1000
    
    let pdfVC = UIHostingController(rootView: expenseList)
    pdfVC.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
    
    //Render the view behind all other views
    let rootVC = UIApplication.shared.currentUIWindow()!.rootViewController
    rootVC?.addChild(pdfVC)
    rootVC?.view.insertSubview(pdfVC.view, at: 0)
    
    //Render the PDF
    let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 8.5 * 72.0, height: height))
    
    do {
      try pdfRenderer.writePDF(to: outputFileURL, withActions: { (context) in
        context.beginPage()
        pdfVC.view.layer.render(in: context.cgContext)
      })
      
      self.viewModel.PDFUrl = outputFileURL
      self.viewModel.showShareSheet = true
      
    }catch {
      print("Could not create PDF file: \(error)")
    }
    
    pdfVC.removeFromParent()
    pdfVC.view.removeFromSuperview()
  }
  
}


struct ReportsView_Previews: PreviewProvider {
  static var previews: some View {
    ReportsView(viewModel: ReportsViewModel(), startDate: .constant(Date.now), endDate: .constant(Date.now))
  }
}
