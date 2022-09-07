//
//  GlobalTools.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 9/6/22.
//

import SwiftUI
import Combine

class GlobalTools: ObservableObject {

  @Published var myFormatter: NumberFormatter
  
  init(myFormatter: NumberFormatter) {
    self.myFormatter = myFormatter
    myFormatter.maximumFractionDigits = 2
  }
}
