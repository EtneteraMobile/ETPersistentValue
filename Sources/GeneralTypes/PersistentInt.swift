//
//  PersistentInt.swift
//  ETPersistentValue
//
//  Created by Jan Čislinský on 31/07/2017.
//
//

import Foundation

open class PersistentInt: PersistentValue<Int> {
    internal override func toUserDefaults(_ input: Int) -> Any {
        return NSNumber(integerLiteral: input)
    }

    internal override func fromUserDefaults(_ input: Any?) -> Int? {
        return (input as? NSNumber)?.intValue
    }
}
