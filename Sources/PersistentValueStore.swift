//
//  PersistentValueStore.swift
//  ETPersistentValue iOS
//
//  Created by Jan Čislinský on 13. 05. 2019.
//

import Foundation

class PersistentValueStore<T>: PersistentValueType {
    typealias ValueType = T

    var value: ValueType?

    init(_ value: ValueType?) {
        self.value = value
    }

    func save() {}

    func save(updating: (ValueType?) -> ValueType?) {}

    func fetch() {}

    func remove() {}
}
