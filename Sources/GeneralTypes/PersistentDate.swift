//
//  PersistentDate.swift
//  ETPersistentValue iOS
//
//  Created by Jan Čislinský on 02/09/2017.
//

import Foundation

open class PersistentDate: BoxedPersistentValue<Date> {
    // MARK: - UserDefaults Initialization

    /// Initializes `PersistentValue` and loads it from the `UserDefaults` by the defined key.
    ///
    /// - Parameters:
    ///   - key: Identificator of the value.
    ///   - userDefaults: Instance of UserDefaults.
    public init(key: CustomStringConvertible, userDefaults: UserDefaults = UserDefaults.standard) {
        super.init(PersistentUserDefaultsValue<ValueType>(key: key, userDefaults: userDefaults))
    }

    /// Initializes `PersistentValue` but doesn't save it into `UserDefaults` right away. You need to call `save()` for that.
    ///
    /// - Parameters:
    ///   - key: Identificator of the value.
    ///   - value: Value which should be saved.
    ///   - userDefaults: Instance of UserDefaults.
    public init(key: CustomStringConvertible, value: ValueType, userDefaults: UserDefaults = UserDefaults.standard) {
        super.init(PersistentUserDefaultsValue<ValueType>(key: key, value: value, userDefaults: userDefaults))
    }
}
