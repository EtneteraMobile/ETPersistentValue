//
//  ETPersistentCodableTests.swift
//  ETPersistentValueTests
//
//  Created by Jan Kodeš on 17/08/2018.
//

import Foundation
import XCTest
@testable import ETPersistentValue

class KeychainStoreStringTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        PersistentString(account: Account.stringValue).remove()
    }

    override func tearDown() {
        super.tearDown()
        PersistentString(account: Account.stringValue).remove()
    }
    
    // MARK: -

    func test_NoneValueAfterInit() {
        // when
        let bool = PersistentString(account: Account.stringValue)

        // then
        XCTAssertNil(bool.value)
    }

    func test_FetchValueAfterInit() {
        // given
        PersistentString(value: "test", account: Account.stringValue).save()

        // when
        let value = PersistentString(account: Account.stringValue).value

        // then
        XCTAssertNotNil(value)
        if let v = value {
            XCTAssertEqual(v, "test")
        }
    }

    func test_ValueSave() {
        // given
        let value = PersistentString(account: Account.stringValue)

        // when
        value.value = "test NO"
        value.save()

        // then
        let result = PersistentString(account: Account.stringValue).value
        XCTAssertNotNil(result)
        if let v = result {
            XCTAssertEqual(v, "test NO")
        }
    }

    func test_ValueSaveAfterInit() {
        // when
        PersistentString(value: "test NO", account: Account.stringValue).save()

        // then
        let value = PersistentString(account: Account.stringValue).value
        XCTAssertNotNil(value)
        if let v = value {
            XCTAssertEqual(v, "test NO")
        }
    }

    func test_UpdateValue() {
        // given
        PersistentString(value: "test NO", account: Account.stringValue).save()

        // when
        PersistentString(value: "test", account: Account.stringValue).save()

        // then
        let savedValue = PersistentString(account: Account.stringValue).value
        XCTAssertNotNil(savedValue)
        if let v = savedValue {
            XCTAssertEqual(v, "test")
        }
    }

    func test_SaveNilValue() {
        // given
        PersistentString(value: "test", account: Account.stringValue).save()

        // when
        PersistentString(value: nil, account: Account.stringValue).save()

        // then
        XCTAssertNil(PersistentString(account: Account.stringValue).value)
    }

    func test_SaveNilValueWithUpdating() {
        // when
        let value = PersistentString(account: Account.stringValue)
        value.save { _ in
            "test"
        }

        // then
        let savedValue = PersistentString(account: Account.stringValue).value
        XCTAssertNotNil(savedValue)
        if let v = savedValue {
            XCTAssertEqual(v, "test")
        }
    }

    func test_SaveNonNilValueWithUpdating() {
        // given
        PersistentString(value: "test NO", account: Account.stringValue).save()

        // when
        let value = PersistentString(account: Account.stringValue)
        value.save { _ in
            "test"
        }

        // then
        let savedValue = PersistentString(account: Account.stringValue).value
        XCTAssertNotNil(savedValue)
        if let v = savedValue {
            XCTAssertEqual(v, "test")
        }
    }

    func test_RemoveExistingValue() {
        // given
        let value = PersistentString(value: "test", account: Account.stringValue)
        value.save()

        // when
        value.remove()

        // then
        XCTAssertNil(PersistentString(account: Account.stringValue).value)
    }

    func test_RemoveNonExistingValue() {
        // given
        let value = PersistentString(account: Account.stringValue)

        // when
        value.remove()

        // then
        XCTAssertNil(PersistentString(account: Account.stringValue).value)
    }

    enum Account: String, CustomStringConvertible {
        case stringValue = "stringValue"

        var description: String {
            return rawValue
        }
    }
}
