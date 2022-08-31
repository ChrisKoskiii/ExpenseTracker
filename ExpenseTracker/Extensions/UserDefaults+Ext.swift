//
//  UserDefaults+Ext.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 8/31/22.
//

import Foundation

extension UserDefaults {
    func decode<T: Decodable>(_ type: T.Type, forKey defaultName: String) throws -> T {
        try JSONDecoder().decode(T.self, from: data(forKey: defaultName) ?? .init())
    }
    func encode<T: Encodable>(_ value: T, forKey defaultName: String) throws {
        try set(JSONEncoder().encode(value), forKey: defaultName)
    }
}
