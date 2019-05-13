//
//  ETPersistentValueTests.swift
//  ETPersistentValueTests
//
//  Created by Jan Kodeš on 17/08/2018.
//

import XCTest
@testable import ETPersistentValue

class KeychainStoreTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        PersistentBool(account: Account.boolValue).remove()
    }
    
    override func tearDown() {
        super.tearDown()
        PersistentBool(account: Account.boolValue).remove()
    }

    // MARK: -
    
    func test_NoneValueAfterInit() {
        // when
        let bool = PersistentBool(account: Account.boolValue)

        // then
        XCTAssertNil(bool.value)
    }

    func test_FetchValueAfterInit() {
        // given
        PersistentBool(value: true, account: Account.boolValue).save()

        // when
        let value = PersistentBool(account: Account.boolValue).value

        // then
        XCTAssertNotNil(value)
        if let v = value {
            XCTAssertTrue(v)
        }
    }

    func test_ValueSave() {
        // given
        let value = PersistentBool(value: false, account: Account.boolValue)

        // when
        value.value = false
        value.save()

        // then
        let result = PersistentBool(account: Account.boolValue).value
        XCTAssertNotNil(result)
        if let v = result {
            XCTAssertFalse(v)
        }
    }
    
    func test_ValueSaveAfterInit() {
        // when
        PersistentBool(value: false, account: Account.boolValue).save()

        // then
        let value = PersistentBool(account: Account.boolValue).value
        XCTAssertNotNil(value)
        if let v = value {
            XCTAssertFalse(v)
        }
    }

    func test_UpdateValue() {
        // given
        PersistentBool(value: false, account: Account.boolValue).save()

        // when
        PersistentBool(value: true, account: Account.boolValue).save()

        // then
        let savedValue = PersistentBool(account: Account.boolValue).value
        XCTAssertNotNil(savedValue)
        if let v = savedValue {
            XCTAssertTrue(v)
        }
    }

    func test_SaveNilValue() {
        // given
        PersistentBool(value: true, account: Account.boolValue).save()

        // when
        PersistentBool(value: nil, account: Account.boolValue).save()

        // then
        XCTAssertNil(PersistentBool(account: Account.boolValue).value)
    }

    func test_SaveNilValueWithUpdating() {
        // when
        let value = PersistentBool(account: Account.boolValue)
        value.save { _ in
            true
        }

        // then
        let savedValue = PersistentBool(account: Account.boolValue).value
        XCTAssertNotNil(savedValue)
        if let v = savedValue {
            XCTAssertTrue(v)
        }
    }

    func test_SaveNonNilValueWithUpdating() {
        // given
        PersistentBool(value: false, account: Account.boolValue).save()

        // when
        let value = PersistentBool(account: Account.boolValue)
        value.save { _ in
            true
        }

        // then
        let savedValue = PersistentBool(account: Account.boolValue).value
        XCTAssertNotNil(savedValue)
        if let v = savedValue {
            XCTAssertTrue(v)
        }
    }

    func test_RemoveExistingValue() {
        // given
        let value = PersistentBool(value: true, account: Account.boolValue)
        value.save()

        // when
        value.remove()

        // then
        XCTAssertNil(PersistentBool(account: Account.boolValue).value)
    }

    func test_RemoveNonExistingValue() {
        // given
        let value = PersistentBool(account: Account.boolValue)

        // when
        value.remove()

        // then
        XCTAssertNil(PersistentBool(account: Account.boolValue).value)
    }

    enum Account: String, CustomStringConvertible {
        case boolValue = "boolValue"
        
        var description: String {
            return rawValue
        }
    }
}
