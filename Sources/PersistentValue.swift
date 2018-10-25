//
//  PersistentValue.swift
//  ETPersistentValue
//
//  Created by Jan Čislinský on 31/07/2017.
//
//

import Foundation

/// `PersistentValue` offers saving and loading capabilities of primitive types
/// which can be used by subclasses like `PersistentFloat`, `PersistentBool` etc.
/// Also supports a `PersistentCodable` which expects a type that conforms to `Codable` protocol.
open class PersistentValue<ValueType> {

    // MARK: - Variables
    // MARK: public

    open var value: ValueType?
    public let key: String

    // MARK: private

    private let userDefaults: UserDefaults

    // MARK: - Initialization
    
    /// Initializes `PersistentValue` and loads it from the `UserDefaults` by the defined key.
    ///
    /// - Parameters:
    ///   - key: Identificator of the value.
    ///   - userDefaults: Instance of UserDefaults.
    public init(key: CustomStringConvertible, userDefaults: UserDefaults = UserDefaults.standard) {
        self.key = key.description
        self.userDefaults = userDefaults
        self.value = load(self.userDefaults, self.key)
    }
    
    /// Initializes `PersistentValue` but doesn't save it into `UserDefaults` right away. You need to call `save()` for that.
    ///
    /// - Parameters:
    ///   - key: Identificator of the value.
    ///   - value: Value which should be saved.
    ///   - userDefaults: Instance of UserDefaults.
    public init(key: CustomStringConvertible, value: ValueType, userDefaults: UserDefaults = UserDefaults.standard) {
        self.key = key.description
        self.userDefaults = userDefaults
        self.value = value
    }

    // MARK: - Actions
    // MARK: public

    /// Saves a value into `UserDefaults`.
    /// Removes a value from `UserDefaults` if `value` is `nil`
    open func save() {
        if let value = value {
            userDefaults.set(toUserDefaults(value), forKey: key)
            userDefaults.synchronize()
        } else {
            remove()
        }
    }

    /// Loads a value from `UserDefaults`.
    open func fetch() {
        value = load(userDefaults, key)
    }

    /// Removes a value from `UserDefaults`.
    open func remove() {
        value = nil
        userDefaults.removeObject(forKey: key)
        userDefaults.synchronize()
    }

    // MARK: internal

    /// - Parameter input: Value for saving.
    /// - Returns: A processed value for saving into `UserDefaults`.
    open func toUserDefaults(_ input: ValueType) -> Any {
        return input
    }

    /// - Parameter input: Value to be loaded.
    /// - Returns: A loaded value from `UserDefaults`.
    open func fromUserDefaults(_ input: Any?) -> ValueType? {
        return input as? ValueType
    }

    // MARK: private

    /// Loads value from `UserDefaults`
    ///
    /// - Parameters:
    ///   - key: Identificator of the value saved in `UserDefaults`.
    ///   - userDefaults: Instance of `UserDefaults`.
    private func load(_ userDefaults: UserDefaults, _ key: String) -> ValueType? {
        return fromUserDefaults(userDefaults.object(forKey: key) as AnyObject)
    }
}
