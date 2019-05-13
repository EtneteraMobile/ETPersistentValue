//
//  PersistentInt.swift
//  ETPersistentValue
//
//  Created by Jan Čislinský on 31/07/2017.
//
//

import Foundation

open class PersistentInt: PersistentValue<Int> {
    // MARK: - UserDefaults Initialization

    /// Initializes `PersistentValue` and loads it from the `UserDefaults` by the defined key.
    ///
    /// - Parameters:
    ///   - key: Identificator of the value.
    ///   - userDefaults: Instance of UserDefaults.
    public init(key: CustomStringConvertible, userDefaults: UserDefaults = UserDefaults.standard) {
        super.init(UserDefaultsStore<ValueType>(key: key, userDefaults: userDefaults))
    }

    /// Initializes `PersistentValue` but doesn't save it into `UserDefaults` right away. You need to call `save()` for that.
    ///
    /// - Parameters:
    ///   - key: Identificator of the value.
    ///   - value: Value which should be saved.
    ///   - userDefaults: Instance of UserDefaults.
    public init(key: CustomStringConvertible, value: ValueType, userDefaults: UserDefaults = UserDefaults.standard) {
        super.init(UserDefaultsStore<ValueType>(key: key, value: value, userDefaults: userDefaults))
    }
}
