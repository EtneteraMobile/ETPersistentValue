//
//  PersistentValueType.swift
//  ETPersistentValue iOS
//
//  Created by Jan Čislinský on 13. 05. 2019.
//

import Foundation

public protocol PersistentValueType {
    associatedtype ValueType

    var value: ValueType? { get set }

    func save()
    func save(updating: (ValueType?) -> ValueType?)
    func fetch()
    func remove()
}
