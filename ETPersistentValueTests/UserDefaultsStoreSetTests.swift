//
//  ETPersistentSetTests.swift
//  ETPersistentValueTests
//
//  Created by Jan Kodeš on 17/08/2018.
//

import XCTest
import ETPersistentValue

class UserDefaultsStoreSetTests: XCTestCase {
    
    var userDefaults = UserDefaults(suiteName: "testSuite")!
    let key = "testSet"
    
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
    
    func test_SetValueSave() {
        // g
//        var set = Set<Hedgehog>()
//        set.insert(Hedgehog.anna)
//        set.insert(Hedgehog.carlos)
        
        var set = Set<Int>()
        set.insert(20)
        set.insert(30)
        
        // when
        let persistentSet = PersistentSet(key: key, value: set, userDefaults: userDefaults)
        persistentSet.save()
        
        // then
        let savedObject = userDefaults.array(forKey: key)
        XCTAssert(savedObject?.count == 2)
        XCTAssert(persistentSet.value?.count == savedObject?.count)
        XCTAssert(persistentSet.value?.first == savedObject?.first as? Int)
    }
    
    func test_SetValueLoad() {
        // g
        userDefaults.set([20, 30], forKey: key)

        // w
        let persistentSet = PersistentSet<Int>(key: key, userDefaults: userDefaults)

        // t
        XCTAssertEqual(persistentSet.value?.count, 2)
        XCTAssert(persistentSet.value?.contains(20) == true)
        XCTAssert(persistentSet.value?.contains(30) == true)
    }
    
    func test_SetValueLoadIncorrectData() {
        // g
        userDefaults.set(20, forKey: key)
        
        // w
        let persistentSet = PersistentSet<Int>(key: key, userDefaults: userDefaults)
        persistentSet.fetch()
        
        // t
        XCTAssert(persistentSet.value == [])
    }
}
