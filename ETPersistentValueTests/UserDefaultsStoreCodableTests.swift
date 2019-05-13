//
//  ETPersistentCodableTests.swift
//  ETPersistentValueTests
//
//  Created by Jan Kodeš on 17/08/2018.
//

import Foundation
import XCTest
@testable import ETPersistentValue

class UserDefaultsStoreCodableTests: XCTestCase {
    
    var userDefaults = UserDefaults(suiteName: "testSuite")!
    let key = "codableHedgehog"
    
    override func setUp() {
        super.setUp()
        userDefaults = UserDefaults(suiteName: "testSuite")!
        userDefaults.cleanObjects()
    }
    
    override func tearDown() {
        super.tearDown()
        userDefaults.cleanObjects()
        userDefaults.removeSuite(named: "testSuite")
    }
    
    func test_CodableArrayValueSave() {
        // given
        let carlos = Hedgehog(name: "Speedy Carlos", alive: false, sex: .male, friends: nil, birthday: Date(timeIntervalSinceReferenceDate: -123456789.0))
        let anna = Hedgehog(name: "Swifty Anna", alive: true, sex: .female, friends: [carlos], birthday: Date(timeIntervalSinceReferenceDate: -123456789.0))
        
        // when
        let persistentCodable = PersistentCodable(key: key, value: [anna,carlos], userDefaults: userDefaults)
        persistentCodable.save()
        
        // then
        let savedObject = PersistentCodable<[Hedgehog]>(key: key, userDefaults: userDefaults)
        XCTAssert(persistentCodable.value == savedObject.value)
    }
    
    func test_LoadNotDecodableData_DataGuardFailsAndReturnsNil() {
        // given
        let json = "{'test': 'Test Json'}"
        userDefaults.set(json, forKey: key)
        
        // when
        let loadedCodable = PersistentCodable<Hedgehog>(key: key, userDefaults: userDefaults)
        
        // then
        XCTAssertNil(loadedCodable.value)
    }
}
