//
//  PersistentCodable.swift
//  ETPersistentValue iOS
//
//  Created by Jan Kodeš on 17/08/2018.
//

import Foundation

open class PersistentCodable<ValueType: Codable>: PersistentValue<ValueType> {
    
    /// Encodes `Codable` object into `JSON` and returns it.
    /// - Parameter input: Value for saving. Can be an `Array` of `Codable` objects.
    /// - Returns: A processed `Codable` object for saving into `UserDefaults`.
    override open func toUserDefaults(_ input: ValueType) -> Any {
        do {
            let encoder = JSONEncoder()
            return try encoder.encode(input)
        } catch {
            preconditionFailure("Failed to encode data with error: \(error)")
        }
    }
    
    /// Decodes `JSON` into `Codable` object and returns it.
    /// - Parameter input: Loaded value from `UserDefaults`.
    /// - Returns: A loaded `Codable` object.
    override open func fromUserDefaults(_ input: Any?) -> ValueType? {
        guard let data = input as? Data else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            let decoded = try decoder.decode(ValueType.self, from: data)
            return decoded
        } catch {
            print(error)
            return nil
        }
    }

}
