//
//  CrashTestView.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 8/26/22.
//

import SwiftUI
import AppCenterCrashes

struct CrashTestView: View {
    var body: some View {
      Button("Crash") {
        Crashes.generateTestCrash()
      }
    }
}

struct CrashTestView_Previews: PreviewProvider {
    static var previews: some View {
        CrashTestView()
    }
}
