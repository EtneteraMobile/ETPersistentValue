//
//  PersistentValue.swift
//  ETPersistentValue
//
//  Created by Jan Čislinský on 31/07/2017.
//
//

import Foundation

/// `UserDefaultsStore` offers saving and loading capabilities of
/// primitive types into UserDefaults.
open class UserDefaultsStore<ValueType>: BaseStore<ValueType> {

    // MARK: - Variables
    // MARK: public

    /// The key that is used in UserDefaults
    public let key: String

    // MARK: private

    private let userDefaults: UserDefaults

    private let convertFrom: (_ input: Any?) -> ValueType?
    private let convertTo: (_ input: ValueType) -> Any

    // MARK: - Initialization
    
    /// Initializes `UserDefaultsStore` and loads the value from the
    /// `UserDefaults`.
    ///
    /// - Parameters:
    ///   - key: Identificator of the value.
    ///   - userDefaults: Instance of UserDefaults.
    ///   - convertFrom: Closure that converts `Any` from UserDefault to `ValueType`.
    ///   - convertTo: Closure that converts `ValueType` into `Any` for UserDefaults.
    public init(key: CustomStringConvertible, userDefaults: UserDefaults = UserDefaults.standard, convertFrom: ((_ input: Any?) -> ValueType?)? = nil, convertTo: ((_ input: ValueType) -> Any)? = nil) {
        self.key = key.description
        self.userDefaults = userDefaults
        self.convertFrom = convertFrom ?? { $0 as? ValueType }
        self.convertTo = convertTo ?? { $0 }
        super.init(self.convertFrom(userDefaults.object(forKey: key.description) as AnyObject))
    }
    
    /// Initializes `UserDefaultsStore` with given value.
    ///
    /// - Attention: Value isn't saved it into `UserDefaults` right away. You need to call `save()` for that.
    ///
    /// - Parameters:
    ///   - key: Identificator of the value.
    ///   - value: Value which should be saved.
    ///   - userDefaults: Instance of UserDefaults.
    ///   - convertFrom: Closure that converts `Any` from UserDefault to `ValueType`.
    ///   - convertTo: Closure that converts `ValueType` into `Any` for UserDefaults.
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
    override open func save() {
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
    override open func save(updating: (ValueType?) -> ValueType?) {
        value = updating(value)
        save()
    }

    /// Loads a value from `UserDefaults`.
    override open func fetch() {
        value =  convertFrom(userDefaults.object(forKey: key) as AnyObject)
    }

    /// Removes a value from `UserDefaults`.
    override open func remove() {
        value = nil
        userDefaults.removeObject(forKey: key)
        userDefaults.synchronize()
    }
}
