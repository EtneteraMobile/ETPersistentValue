//
//  PersistentValueStore.swift
//  ETPersistentValue iOS
//
//  Created by Jan Čislinský on 13. 05. 2019.
//

import Foundation

/// Empty implementation of `PersistentValueType` that should be overriden by concrete Store.
open class BaseStore<T>: PersistentValueType {
    public typealias ValueType = T

    public var value: ValueType?

    public init(_ value: ValueType?) {
        self.value = value
    }

    open func save() {}

    open func save(updating: (ValueType?) -> ValueType?) {}

    open func fetch() {}

    open func remove() {}
}
