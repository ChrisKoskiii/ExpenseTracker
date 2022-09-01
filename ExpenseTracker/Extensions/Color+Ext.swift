//
//  Color+Ext.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 8/11/22.
//

import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

extension Color {
  
  var components: (r: Double, g: Double, b: Double, a: Double) {
    
#if canImport(UIKit)
    typealias NativeColor = UIColor
#elseif canImport(AppKit)
    typealias NativeColor = NSColor
#endif
    
    var r: CGFloat = 0
    var g: CGFloat = 0
    var b: CGFloat = 0
    var a: CGFloat = 0
    
    guard NativeColor(self).getRed(&r, green: &g, blue: &b, alpha: &a) else { return (0,0,0,0) }
    
    return (Double(r), Double(g), Double(b), Double(a))
  }
}

extension Color {
  static let brandPrimary   = Color("brandPrimary")
  static let brandSecondary = Color("brandSecondary")
  static let recentTextColor = Color("RecentTextColor")
}

