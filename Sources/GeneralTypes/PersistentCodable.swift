//
//  PersistentCodable.swift
//  ETPersistentValue iOS
//
//  Created by Jan Kodeš on 17/08/2018.
//

import Foundation

open class PersistentCodable<ValueType: Codable>: PersistentValue<ValueType> {
    // MARK: - UserDefaults Initialization
    
    /// Initializes `PersistentValue` and loads it from the `UserDefaults` by the defined key.
    ///
    /// - Parameters:
    ///   - key: Identificator of the value.
    ///   - userDefaults: Instance of UserDefaults.
    public init(key: CustomStringConvertible, userDefaults: UserDefaults = UserDefaults.standard) {
        super.init(UserDefaultsStore<ValueType>(key: key, userDefaults: userDefaults, convertFrom: PersistentCodable.fromUserDefaults, convertTo: PersistentCodable.toUserDefaults))
    }

    /// Initializes `PersistentValue` but doesn't save it into `UserDefaults` right away. You need to call `save()` for that.
    ///
    /// - Parameters:
    ///   - key: Identificator of the value.
    ///   - value: Value which should be saved.
    ///   - userDefaults: Instance of UserDefaults.
    public init(key: CustomStringConvertible, value: ValueType, userDefaults: UserDefaults = UserDefaults.standard) {
        super.init(UserDefaultsStore<ValueType>(key: key, value: value, userDefaults: userDefaults, convertFrom: PersistentCodable.fromUserDefaults, convertTo: PersistentCodable.toUserDefaults))
    }

    /// Encodes `Codable` object into `JSON` and returns it.
    /// - Parameter input: Value for saving. Can be an `Array` of `Codable` objects.
    /// - Returns: A processed `Codable` object for saving into `UserDefaults`.
    class func toUserDefaults(_ input: ValueType) -> Any {
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
    class func fromUserDefaults(_ input: Any?) -> ValueType? {
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
