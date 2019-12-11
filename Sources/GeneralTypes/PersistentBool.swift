//
//  PersistentBool.swift
//  ETPersistentValue
//
//  Created by Jan Čislinský on 31/07/2017.
//
//

import Foundation

open class PersistentBool: PersistentValue<Bool> {
    // MARK: - UserDefaults Initialization

    /// Initializes `PersistentValue` and loads it from the **UserDefaults** by the defined key.
    ///
    /// - Parameters:
    ///   - key: Identificator of the value.
    ///   - userDefaults: Instance of UserDefaults.
    public init(key: CustomStringConvertible, userDefaults: UserDefaults = UserDefaults.standard) {
        super.init(UserDefaultsStore<ValueType>(key: key, userDefaults: userDefaults))
    }

    /// Initializes `PersistentValue` with given value.
    ///
    /// - Parameters:
    ///   - key: Identificator of the value.
    ///   - value: Value which should be saved.
    ///   - userDefaults: Instance of UserDefaults.
    ///
    /// - Attention: Value isn't saved it into store right away. You need to call `save()` for that.
    public init(key: CustomStringConvertible, value: ValueType, userDefaults: UserDefaults = UserDefaults.standard) {
        super.init(UserDefaultsStore<ValueType>(key: key, value: value, userDefaults: userDefaults))
    }

    // MARK: - Keychain Initialization

    /// Initialized `PersistentValue` and loads it from **Keychain**.
    ///
    /// - Parameters:
    ///   - account: Account for value identification in Keychain.
    ///   - service: Service for value identification in Keychain.
    public init(account: CustomStringConvertible, service: CustomStringConvertible = KeychainDefaultService) {
        let store = KeychainStore<Bool>(account: account, service: service, convertFrom: type(of: self).fromData, convertTo: type(of: self).toData)
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
        let store = KeychainStore<Bool>(value: value, account: account, service: service, convertFrom: type(of: self).fromData, convertTo: type(of: self).toData)
        super.init(store)
    }

    class func toData(_ input: ValueType) -> Data {
        var value = input
        return Data(bytes: &value, count: MemoryLayout.size(ofValue: value))
    }

    class func fromData(_ input: Data?) -> ValueType? {
        return input?[0] == 1
    }
}
