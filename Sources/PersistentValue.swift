//
//  BoxedPersistentValue.swift
//  ETPersistentValue iOS
//
//  Created by Jan Čislinský on 13. 05. 2019.
//

import Foundation

/// Persists value in one of the supported stores. In which store is value
/// persisted is selected in `init.
///
/// `PersistentValue` bridges `self.value` with `BaseStore`.
///
/// All requirements from `PersistentValueType` are bridged to internal
/// `BaseStore` (like UserDefaultsStore, KeychainStore).
open class PersistentValue<T>: PersistentValueType {
    public typealias ValueType = T

    /// Persistet value
    public var value: ValueType? {
        get {
            return valueStore.value
        }
        set {
            valueStore.value = newValue
        }
    }
    internal let valueStore: BaseStore<ValueType>

    // MARK: - Initialization

    internal init(_ store: BaseStore<ValueType>) {
        self.valueStore = store
    }

    // MARK: - Actions
    // MARK: public

    /// Saves current value synchronously into store.
    public func save() {
        valueStore.save()
    }

    /// Saves updated value by given closure synchronously into store.
    public func save(updating: (ValueType?) -> ValueType?) {
        valueStore.save(updating: updating)
    }

    /// Fetches value from store.
    public func fetch() {
        valueStore.fetch()
    }

    /// Removes value from store.
    public func remove() {
        valueStore.remove()
    }
}
