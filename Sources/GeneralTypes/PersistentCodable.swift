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
    ///
    /// - Attention: Value isn't saved it into store right away. You need to call `save()` for that.
    public init(key: CustomStringConvertible, value: ValueType, userDefaults: UserDefaults = UserDefaults.standard) {
        super.init(UserDefaultsStore<ValueType>(key: key, value: value, userDefaults: userDefaults, convertFrom: PersistentCodable.fromUserDefaults, convertTo: PersistentCodable.toUserDefaults))
    }

    /// Encodes `Codable` object into `JSON` and returns it.
    /// - Parameter input: Value for saving. Can be an `Array` of `Codable` objects.
    /// - Returns: A processed `Codable` object for saving into `UserDefaults`.
    class func toUserDefaults(_ input: ValueType) -> Any {
        return toData(input)
    }

    /// Decodes `JSON` into `Codable` object and returns it.
    /// - Parameter input: Loaded value from `UserDefaults`.
    /// - Returns: A loaded `Codable` object.
    class func fromUserDefaults(_ input: Any?) -> ValueType? {
        guard let data = input as? Data else {
            return nil
        }

        return fromData(data)
    }

    // MARK: - Keychain Initialization

    /// Initialized `PersistentValue` and loads it from **Keychain**.
    ///
    /// - Parameters:
    ///   - account: Account for value identification in Keychain.
    ///   - service: Service for value identification in Keychain.
    public init(account: CustomStringConvertible, service: CustomStringConvertible = KeychainDefaultService) {
        let store = KeychainStore<ValueType>(account: account, service: service, convertFrom: type(of: self).fromData, convertTo: type(of: self).toData)
        super.init(store)
    }

    /// Initialized `PersistentValue` with given value.
    ///
    /// - Parameters:
    ///   - value: Initial value
    ///   - account: Account for value identification in Keychain.
    ///   - service: Service for value identification in Keychain.
    ///
    /// - Attention: Value isn't saved it into store right away. You need to call `save()` for that.
    public init(value: ValueType?, account: CustomStringConvertible, service: CustomStringConvertible = KeychainDefaultService) {
        let store = KeychainStore<ValueType>(value: value, account: account, service: service, convertFrom: type(of: self).fromData, convertTo: type(of: self).toData)
        super.init(store)
    }

    class func toData(_ input: ValueType) -> Data {
        do {
            let encoder = JSONEncoder()
            return try encoder.encode(input)
        } catch {
            preconditionFailure("Failed to encode data with error: \(error)")
        }
    }

    class func fromData(_ input: Data?) -> ValueType? {
        guard let data = input else {
            return nil
        }

        do {
            let decoder = JSONDecoder()
            let decoded = try decoder.decode(ValueType.self, from: data)
            return decoded
        } catch {
            preconditionFailure("Failed to decode data with error: \(error)")
        }
    }
}
