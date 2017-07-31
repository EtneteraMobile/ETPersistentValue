//
//  PersistentBool.swift
//  ETPersistentValue
//
//  Created by Jan Čislinský on 31/07/2017.
//
//

import Foundation

open class PersistentBool: PersistentValue<Bool> {
    internal override func toUserDefaults(_ input: Bool) -> Any {
        return NSNumber(value: input)
    }

    internal override func fromUserDefaults(_ input: Any?) -> Bool? {
        return (input as? NSNumber)?.boolValue
    }
}
