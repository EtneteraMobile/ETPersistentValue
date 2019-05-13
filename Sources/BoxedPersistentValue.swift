//
//  BoxedPersistentValue.swift
//  ETPersistentValue iOS
//
//  Created by Jan Čislinský on 13. 05. 2019.
//

import Foundation

open class BoxedPersistentValue<T>: PersistentValueType {
    public typealias ValueType = T

    public var value: ValueType? {
        get {
            return valueBox.value
        }
        set {
            valueBox.value = newValue
        }
    }
    internal let valueBox: PersistentValueStore<ValueType>

    // MARK: - Initialization

    internal init(_ box: PersistentValueStore<ValueType>) {
        self.valueBox = box
    }

    // MARK: - Actions
    // MARK: public

    public func save() {
        valueBox.save()
    }

    public func save(updating: (ValueType?) -> ValueType?) {
        valueBox.save(updating: updating)
    }

    public func fetch() {
        valueBox.fetch()
    }

    public func remove() {
        valueBox.remove()
    }
}
