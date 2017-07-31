//
//  PersistentFloat.swift
//  ETPersistentValue
//
//  Created by Jan Čislinský on 31/07/2017.
//
//

import Foundation

open class PersistentFloat: PersistentValue<Float> {
    internal override func toUserDefaults(_ input: Float) -> Any {
        return NSNumber(value: input)
    }

    internal override func fromUserDefaults(_ input: Any?) -> Float? {
        return (input as? NSNumber)?.floatValue
    }
}
