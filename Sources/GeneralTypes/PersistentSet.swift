//
//  PersistentSet.swift
//  ETPersistentValue
//
//  Created by Jan Čislinský on 31/07/2017.
//
//

import Foundation

open class PersistentSet<Element: Hashable>: PersistentValue<Set<Element>> {
    internal override func toUserDefaults(_ input: Set<Element>) -> Any {
        let a = Array(input)
        return a
    }

    internal override func fromUserDefaults(_ input: Any?) -> Set<Element>? {
        if let array = input as? [Element] {
            return Set(array)
        } else {
            return []
        }
    }
}
