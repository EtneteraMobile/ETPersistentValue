//
//  PersistentValue.swift
//  ETPersistentValue
//
//  Created by Jan Čislinský on 31/07/2017.
//
//

import Foundation

/// `PersistentUserDefaultsValue` offers saving and loading capabilities of
/// primitive types which can be used by subclasses like `PersistentFloat`,
/// `PersistentBool` etc. Also supports a `PersistentCodable` which expects
/// a type that conforms to `Codable` protocol.
class PersistentUserDefaultsValue<ValueType>: PersistentValueStore<ValueType> {

    // MARK: - Variables
    // MARK: public

    public let key: String

    // MARK: private

    private let userDefaults: UserDefaults

    private let convertFrom: (_ input: Any?) -> ValueType?
    private let convertTo: (_ input: ValueType) -> Any

    // MARK: - Initialization
    
    /// Initializes `PersistentValue` and loads it from the `UserDefaults` by the defined key.
    ///
    /// - Parameters:
    ///   - key: Identificator of the value.
    ///   - userDefaults: Instance of UserDefaults.
    public init(key: CustomStringConvertible, userDefaults: UserDefaults = UserDefaults.standard, convertFrom: ((_ input: Any?) -> ValueType?)? = nil, convertTo: ((_ input: ValueType) -> Any)? = nil) {
        self.key = key.description
        self.userDefaults = userDefaults
        self.convertFrom = convertFrom ?? { $0 as? ValueType }
        self.convertTo = convertTo ?? { $0 }
        super.init(self.convertFrom(userDefaults.object(forKey: key.description) as AnyObject))
    }
    
    /// Initializes `PersistentValue` but doesn't save it into `UserDefaults` right away. You need to call `save()` for that.
    ///
    /// - Parameters:
    ///   - key: Identificator of the value.
    ///   - value: Value which should be saved.
    ///   - userDefaults: Instance of UserDefaults.
    public init(key: CustomStringConvertible, value: ValueType, userDefaults: UserDefaults = UserDefaults.standard, convertFrom: ((_ input: Any?) -> ValueType?)? = nil, convertTo: ((_ input: ValueType) -> Any)? = nil) {
        self.key = key.description
        self.userDefaults = userDefaults
        self.convertFrom = convertFrom ?? { $0 as? ValueType }
        self.convertTo = convertTo ?? { $0 }
        super.init(value)
    }

    // MARK: - Actions
    // MARK: public

    /// Saves a value into `UserDefaults`.
    /// Removes a value from `UserDefaults` if `value` is `nil`
    override func save() {
        if let value = value {
            userDefaults.set(convertTo(value), forKey: key)
            userDefaults.synchronize()
        } else {
            remove()
        }
    }

    /// Saves a value transformed by given updating closure into `UserDefaults`.
    /// Removes a value from `UserDefaults` if `value` is `nil`
    ///
    /// - parameter updating: Updating closure that receives current value and
    ///     save returned value as a new current.
    override func save(updating: (ValueType?) -> ValueType?) {
        value = updating(value)
        save()
    }

    /// Loads a value from `UserDefaults`.
    override func fetch() {
        value =  convertFrom(userDefaults.object(forKey: key) as AnyObject)
    }

    /// Removes a value from `UserDefaults`.
    override func remove() {
        value = nil
        userDefaults.removeObject(forKey: key)
        userDefaults.synchronize()
    }
}
