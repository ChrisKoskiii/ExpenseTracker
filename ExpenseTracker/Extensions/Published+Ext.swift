//
//  Published+Ext.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 8/23/22.
//

import SwiftUI
import Combine

private var cancellables = [String:AnyCancellable]()

extension Published {
    init(wrappedValue defaultValue: Value, key: String) {
        let value = UserDefaults.standard.object(forKey: key) as? Value ?? defaultValue
        self.init(initialValue: value)
        cancellables[key] = projectedValue.sink { val in
            UserDefaults.standard.set(val, forKey: key)
        }
    }
}
