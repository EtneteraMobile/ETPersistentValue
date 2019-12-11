//
//  ETPersistentCodableTests.swift
//  ETPersistentValueTests
//
//  Created by Jan Kodeš on 17/08/2018.
//

import Foundation
import XCTest
@testable import ETPersistentValue

class KeychainStoreCodableTests: XCTestCase {
    
    let account = "codableHedgehog"
    
    override func setUp() {
        super.setUp()
        PersistentCodable<[Hedgehog]>(account: account).remove()
    }

    override func tearDown() {
        super.tearDown()
        PersistentCodable<[Hedgehog]>(account: account).remove()
    }
    
    func test_CodableArrayValueSave() {
        // given
        let carlos = Hedgehog.carlos
        let anna = Hedgehog.anna
        
        // when
        let persistentCodable = PersistentCodable(value: [anna, carlos], account: account)
        persistentCodable.save()
        
        // then
        let savedObject = PersistentCodable<[Hedgehog]>(account: account)
        XCTAssert(savedObject.value == [anna, carlos])
    }
}
