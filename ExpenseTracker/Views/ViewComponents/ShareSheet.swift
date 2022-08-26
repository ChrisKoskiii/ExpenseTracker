//
//  ShareSheet.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 8/2/22.
//

import SwiftUI

struct ShareSheet: UIViewControllerRepresentable {
  
  var urls: [Any]
  
  func makeUIViewController(context: Context) -> UIActivityViewController {
    let controller = UIActivityViewController(activityItems: urls, applicationActivities: nil)
    
    return controller
  }
  
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    
  }
  
}
