//
//  BoxedPersistentValue.swift
//  ETPersistentValue iOS
//
//  Created by Jan Čislinský on 13. 05. 2019.
//

import Foundation

/// `PersistentValue` bridges `self.value` with `BaseStore`.
///
/// All requirements from `PersistentValueType` are bridged to internal
/// `BaseStore` (like UserDefaultsStore).
open class PersistentValue<T>: PersistentValueType {
    public typealias ValueType = T

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

    public func save() {
        valueStore.save()
    }

    public func save(updating: (ValueType?) -> ValueType?) {
        valueStore.save(updating: updating)
    }

    public func fetch() {
        valueStore.fetch()
    }

    public func remove() {
        valueStore.remove()
    }
}
