//
//  ScanButton.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 9/15/22.
//

import SwiftUI

struct ScanButton: View {
  
  @Binding var showScanner: Bool
  
    var body: some View {
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
}

struct ScanButton_Previews: PreviewProvider {
    static var previews: some View {
      ScanButton(showScanner: .constant(true))
    }
}
