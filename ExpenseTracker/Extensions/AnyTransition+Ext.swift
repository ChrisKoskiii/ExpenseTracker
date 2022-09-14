//
//  AnyTransition+Ext.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 9/13/22.
//

import SwiftUI


extension AnyTransition {
    static var backslide: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .trailing),
            removal: .move(edge: .leading))}
}
