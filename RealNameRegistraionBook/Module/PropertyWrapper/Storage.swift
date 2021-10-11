//
//  Storage.swift
//  iOS_MomDad
//
//  Created by Woody Liu on 2021/8/3.
//

import Foundation

@propertyWrapper
struct Storage<T: Codable> {
    private let key: DefaultsKey<T>
    private let defaultValue: T

    init(key: DefaultsKey<T>, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            // Read value from UserDefaults
            guard let data = UserDefaults.standard.object(forKey: key.key) as? Data else {
                // Return defaultValue when no data in UserDefaults
                return defaultValue
            }

            // Convert data to the desire data type
            let value = try? JSONDecoder().decode(T.self, from: data)
            return value ?? defaultValue
        }
        set {
            // Convert newValue to data
            let data = try? JSONEncoder().encode(newValue)
            
            // Set value to UserDefaults
            UserDefaults.standard.set(data, forKey: key.key)
        }
    }
}
