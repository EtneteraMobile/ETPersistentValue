//
//  PersistentSet.swift
//  ETPersistentValue
//
//  Created by Jan Čislinský on 31/07/2017.
//
//

import Foundation

/// `PersistentSet` offers saving and loading of a `Set` which contains only primitive types.
open class PersistentSet<Element: Hashable>: PersistentValue<Set<Element>> {
    
    /// Converts `Set` into `Array` and returns it.
    /// - Parameter input: Value for saving.
    /// - Returns: A processed `Set` for saving into `UserDefaults`.
    /// - Precondition: `Element` can't be `Codable`
    internal override func toUserDefaults(_ input: Set<Element>) -> Any {
        if Element.self is Codable {
            preconditionFailure("Codable elements are not supported")
        } else {
            let a = Array(input)
            return a
        }
    }

    /// Converts `Array` into `Set` and returns it.
    /// - Parameter input: Loaded value from `UserDefaults`.
    /// - Returns: A processed `Set` from `Array`.
    internal override func fromUserDefaults(_ input: Any?) -> Set<Element>? {
        if let array = input as? [Element] {
            return Set(array)
        } else {
            return []
        }
    }
}
