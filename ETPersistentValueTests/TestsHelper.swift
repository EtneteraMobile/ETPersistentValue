//
//  TestsHelper.swift
//  ETPersistentValueTests
//
//  Created by Jan Kodeš on 17/08/2018.
//

import Foundation
import XCTest

extension UserDefaults {
    
    func cleanObjects() {
        for (key, _) in dictionaryRepresentation() {
            removeObject(forKey: key)
        }
    }
}

extension XCTestCase {
    func given(_ description: String, closure: ()-> Void) {
        closure()
    }
    
    func when(_ description: String, closure: ()-> Void) {
        closure()
    }
    
    func then(_ description: String, closure: ()-> Void) {
        closure()
    }
}
