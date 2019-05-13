//
//  ETPersistentValueTests.swift
//  ETPersistentValueTests
//
//  Created by Jan Kodeš on 17/08/2018.
//

import XCTest
@testable import ETPersistentValue

class UserDefaultsStoreTests: XCTestCase {
    
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
    
    func test_NoneValueAfterInit() {
        let bool = PersistentBool(key: Keys.intValue, userDefaults: userDefaults)
        XCTAssertNil(bool.value)
    }
    
    func test_ValueLoadAfterInit() {
        // given
        let key = Keys.boolValue
        userDefaults.set(true, forKey: key.description)
        
        // when
        let bool = PersistentBool(key: key, userDefaults: userDefaults)
        
        // then
        XCTAssertNotNil(bool.value)
        XCTAssertTrue(bool.value!)
    }
    
    func test_DefaultLoadInit() {
        // when
        let key = Keys.boolValue
        userDefaults.set(true, forKey: key.description)
        
        let value = UserDefaultsStore<Bool>(key: key, userDefaults: userDefaults)

        // then
        XCTAssertNotNil(value.value)
        XCTAssertTrue(value.value!)
    }
    
    func test_ValueSaveAfterInit() {
        let key = Keys.intValue
        
        given("remove object with the key to be saved") {
            userDefaults.removeObject(forKey: key.description)
        }
        
        // when
        let value = UserDefaultsStore(key: key, value: 20, userDefaults: userDefaults)
        value.save()
        
        // then
        then("there is saved bool in user defaults") {
            let savedValue = userDefaults.integer(forKey: key.description)
            XCTAssert(value.value == savedValue)
        }
    }

    func test_SaveNilValueWithUpdating() {
        let key = Keys.intValue

        given("remove object with the key to be saved") {
            userDefaults.removeObject(forKey: key.description)
        }

        // when
        let value = UserDefaultsStore<Int>(key: key, userDefaults: userDefaults)
        value.save {
            $0 ?? -1
        }

        // then
        then("there is saved int in user defaults") {
            let savedValue = userDefaults.integer(forKey: key.description)
            XCTAssert(-1 == savedValue)
            XCTAssert(value.value == savedValue)
        }
    }

    func test_SaveNonNilValueWithUpdating() {
        let key = Keys.intValue

        given("set default object with the key") {
            userDefaults.set(2, forKey: key.description)
        }

        // when
        let value = UserDefaultsStore<Int>(key: key, userDefaults: userDefaults)
        value.save {
            $0 ?? -1
        }

        // then
        then("there is saved int in user defaults") {
            let savedValue = userDefaults.integer(forKey: key.description)
            XCTAssertEqual(savedValue, 2)
            XCTAssertEqual(savedValue, value.value)
        }
    }
    
    func test_SaveNilValue() {
        // given
        let key = Keys.intValue
        let value = PersistentBool(key: key, value: false, userDefaults: userDefaults)
        
        // when
        value.value = nil
        value.save()
        
        // then
        let savedValue = userDefaults.object(forKey: key.description)
        XCTAssertNil(savedValue)
    }
    
    func test_ValueRemoval() {
        let key = Keys.intValue
        
        // when
        let value = UserDefaultsStore(key: key, value: 20, userDefaults: userDefaults)
        value.save()
        value.remove()
        
        // then
        then("there is saved bool in user defaults") {
            XCTAssertNil(userDefaults.object(forKey: key.description))
        }
    }
    
    var userDefaults = UserDefaults(suiteName: "testSuite")!
    
    enum Keys: String, CustomStringConvertible {
        case intValue = "intValue"
        case boolValue = "boolValue"
        
        var description: String {
            return rawValue
        }
    }
}
