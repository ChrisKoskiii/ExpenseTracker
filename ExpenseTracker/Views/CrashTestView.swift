//
//  CrashTestView.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 8/26/22.
//

import SwiftUI
import AppCenterCrashes
import AppCenterAnalytics

struct CrashTestView: View {
    var body: some View {
      Button("Crash") {
//        Crashes.generateTestCrash()
        Analytics.trackEvent("crash_button_tapped")
      }
      .onAppear {
        Analytics.trackEvent("crash_view_appeared")
      }
    }
}

struct CrashTestView_Previews: PreviewProvider {
    static var previews: some View {
        CrashTestView()
    }
}
