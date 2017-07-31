//
//  PersistentValue.swift
//  ETPersistentValue
//
//  Created by Jan Čislinský on 31/07/2017.
//
//

import Foundation

open class PersistentValue<ValueType> {

    // MARK: - Variables
    // MARK: public

    open var value: ValueType?

    // MARK: private

    fileprivate let userDefaults: UserDefaults
    fileprivate let key: String

    // MARK: - Initialization

    public init(key: CustomStringConvertible, userDefaults: UserDefaults = UserDefaults.standard) {
        self.key = key.description
        self.userDefaults = userDefaults
        self.value = load(self.userDefaults, self.key)
    }

    public init(key: CustomStringConvertible, value: ValueType, userDefaults: UserDefaults = UserDefaults.standard) {
        self.key = key.description
        self.userDefaults = userDefaults
        self.value = value
    }

    // MARK: - Actions
    // MARK: public

    open func save() {
        if let value = value {
            userDefaults.set(toUserDefaults(value), forKey: key)
            userDefaults.synchronize()
        } else {
            remove()
        }
    }

    open func fetch() {
        value = load(userDefaults, key)
    }

    open func remove() {
        value = nil
        userDefaults.removeObject(forKey: key)
        userDefaults.synchronize()
    }

    // MARK: internal

    internal func toUserDefaults(_ input: ValueType) -> Any {
        return input
    }

    internal func fromUserDefaults(_ input: Any?) -> ValueType? {
        return input as? ValueType
    }

    // MARK: private

    fileprivate func load(_ userDefaults: UserDefaults, _ key: String) -> ValueType? {
        return fromUserDefaults(userDefaults.object(forKey: key) as AnyObject)
    }
}
