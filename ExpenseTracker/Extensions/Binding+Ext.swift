//
//  Binding+Ext.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 9/6/22.
//

import SwiftUI

extension Binding {
    func optionalBinding<T>() -> Binding<T>? where T? == Value {
        if let wrappedValue = wrappedValue {
            return Binding<T>(
                get: { wrappedValue },
                set: { self.wrappedValue = $0 }
            )
        } else {
            return nil
        }
    }
}
