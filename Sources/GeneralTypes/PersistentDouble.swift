//
//  PersistentDouble.swift
//  ETPersistentValue
//
//  Created by Jan Čislinský on 31/07/2017.
//
//

import Foundation

open class PersistentDouble: PersistentValue<Double> {
    internal override func toUserDefaults(_ input: Double) -> Any {
        return NSNumber(value: input)
    }

    internal override func fromUserDefaults(_ input: Any?) -> Double? {
        return (input as? NSNumber)?.doubleValue
    }
}
