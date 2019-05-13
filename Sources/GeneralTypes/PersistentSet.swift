//
//  PersistentSet.swift
//  ETPersistentValue
//
//  Created by Jan Čislinský on 31/07/2017.
//
//

import Foundation

/// `PersistentSet` offers saving and loading of a `Set` which contains only primitive types.
open class PersistentSet<Element: Hashable>: PersistentValue<Set<Element>> {
    // MARK: - UserDefaults Initialization
    
    /// Initializes `PersistentValue` and loads it from the `UserDefaults` by the defined key.
    ///
    /// - Parameters:
    ///   - key: Identificator of the value.
    ///   - userDefaults: Instance of UserDefaults.
    public init(key: CustomStringConvertible, userDefaults: UserDefaults = UserDefaults.standard) {
        super.init(UserDefaultsStore<ValueType>(key: key, userDefaults: userDefaults, convertFrom: PersistentSet.fromUserDefaults, convertTo: PersistentSet.toUserDefaults))
    }

    /// Initializes `PersistentValue` but doesn't save it into `UserDefaults` right away. You need to call `save()` for that.
    ///
    /// - Parameters:
    ///   - key: Identificator of the value.
    ///   - value: Value which should be saved.
    ///   - userDefaults: Instance of UserDefaults.
    public init(key: CustomStringConvertible, value: ValueType, userDefaults: UserDefaults = UserDefaults.standard) {
        super.init(UserDefaultsStore<ValueType>(key: key, value: value, userDefaults: userDefaults, convertFrom: PersistentSet.fromUserDefaults, convertTo: PersistentSet.toUserDefaults))
    }

    /// Converts `Set` into `Array` and returns it.
    /// - Parameter input: Value for saving.
    /// - Returns: A processed `Set` for saving into `UserDefaults`.
    /// - Precondition: `Element` can't be `Codable`
    class func toUserDefaults(_ input: Set<Element>) -> Any {
        if Element.self is Codable {
            preconditionFailure("Codable elements are not supported")
        } else {
            let a = Array(input)
            return a
        }
    }

    /// Converts `Array` into `Set` and returns it.
    /// - Parameter input: Loaded value from `UserDefaults`.
    /// - Returns: A processed `Set` from `Array`.
    class func fromUserDefaults(_ input: Any?) -> Set<Element>? {
        if let array = input as? [Element] {
            return Set(array)
        } else {
            return []
        }
    }
}
