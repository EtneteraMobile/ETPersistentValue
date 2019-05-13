//
//  KeychainStore.swift
//  ETPersistentValue iOS
//
//  Created by Jan Čislinský on 13. 05. 2019.
//

import Foundation

public let KeychainDefaultService: CustomStringConvertible = "cz.etnetera.ETPersistentValue-iOS"

// see https://stackoverflow.com/a/37539998/1694526
// Arguments for the keychain queries
private let kSecClassValue = NSString(format: kSecClass)
private let kSecAttrAccountValue = NSString(format: kSecAttrAccount)
private let kSecValueDataValue = NSString(format: kSecValueData)
private let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
private let kSecAttrServiceValue = NSString(format: kSecAttrService)
private let kSecMatchLimitValue = NSString(format: kSecMatchLimit)
private let kSecReturnDataValue = NSString(format: kSecReturnData)
private let kSecMatchLimitOneValue = NSString(format: kSecMatchLimitOne)

open class KeychainStore<ValueType>: BaseStore<ValueType> {
    // MARK: - Variables


    // MARK: private

    private let account: String
    private let service: String
    private let convertFrom: (_ input: Data?) -> ValueType?
    private let convertTo: (_ input: ValueType) -> Data

    // MARK: - Initialization

    public init(account: CustomStringConvertible, service: CustomStringConvertible, convertFrom: @escaping (_ input: Data?) -> ValueType?, convertTo: @escaping (_ input: ValueType) -> Data) {
        self.account = account.description
        self.service = service.description
        self.convertFrom = convertFrom
        self.convertTo = convertTo
        super.init(KeychainStore.fetch(service.description, account.description, convertFrom: convertFrom))
    }

    public init(value: ValueType?, account: CustomStringConvertible, service: CustomStringConvertible, convertFrom: @escaping (_ input: Data?) -> ValueType?, convertTo: @escaping (_ input: ValueType) -> Data) {
        self.account = account.description
        self.service = service.description
        self.convertFrom = convertFrom
        self.convertTo = convertTo
        super.init(value)
    }

    // MARK: - Actions
    // MARK: public

    /// Saves a value into `UserDefaults`.
    /// Removes a value from `UserDefaults` if `value` is `nil`
    override open func save() {
        if let value = value {
            let data = convertTo(value)
            let newDict: [NSString: Any] = [
                kSecClassValue: kSecClassGenericPasswordValue,
                kSecAttrServiceValue: service,
                kSecAttrAccountValue: account,
                kSecValueDataValue: data
            ]

            // Unable to add two items twice, so remove first
            remove()

            let status = SecItemAdd(newDict as CFDictionary, nil)

            if status != errSecSuccess {
                if #available(iOS 11.3, *) {
                    if let err = SecCopyErrorMessageString(status, nil) {
                        fatalError("KeychainStore: save failed with error: \(err)")
                    }
                }
                fatalError("KeychainStore: save value failed \(status)")
            }
        } else {
            remove()
        }
    }

    /// Saves a value transformed by given updating closure into `UserDefaults`.
    /// Removes a value from `UserDefaults` if `value` is `nil`
    ///
    /// - parameter updating: Updating closure that receives current value and
    ///     save returned value as a new current.
    override open func save(updating: (ValueType?) -> ValueType?) {
        value = updating(value)
        save()
    }

    /// Loads a value from `UserDefaults`.
    override open func fetch() {
        value = KeychainStore.fetch(service, account, convertFrom: convertFrom)
    }

    /// Removes a value from `UserDefaults`.
    override open func remove() {
        value = nil
        let keychainQuery: [NSString: Any] = [
            kSecClassValue: kSecClassGenericPasswordValue,
            kSecAttrServiceValue: service,
            kSecAttrAccountValue: account
        ]

        let status = SecItemDelete(keychainQuery as CFDictionary)

        if #available(iOS 11.3, *) {
            print("hovno: " + String(SecCopyErrorMessageString(status, nil)!))
        }
        if status != errSecSuccess && status != errSecItemNotFound {
            if #available(iOS 11.3, *) {
                if let err = SecCopyErrorMessageString(status, nil) {
                    fatalError("KeychainStore: remove failed with error: \(err)")
                }
            }
            fatalError("KeychainStore: remove failed \(status)")
        }
    }

    private class func fetch(_ service: String, _ account: String, convertFrom: (_ input: Data?) -> ValueType?) -> ValueType? {
        var data: AnyObject?

        let query: [NSString: Any] = [
            kSecClassValue: kSecClassGenericPasswordValue,
            kSecAttrServiceValue: service,
            kSecAttrAccountValue: account,
            kSecReturnDataValue: kCFBooleanTrue as Any,
            kSecMatchLimitValue: kSecMatchLimitOneValue
        ]
        let status = SecItemCopyMatching(query as CFDictionary, &data)

        if status == errSecSuccess {
            if let data = data as? Data {
                return convertFrom(data)
            } else {
                return nil
            }
        } else if status == errSecItemNotFound {
            return nil
        } else {
            if #available(iOS 11.3, *) {
                if let err = SecCopyErrorMessageString(status, nil) {
                    fatalError("KeychainStore: fetch failed with error: \(err)")
                }
            }
            fatalError("KeychainStore: fetch failed \(status)")
        }
    }
}
