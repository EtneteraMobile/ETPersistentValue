# PersistentValue for iOS

`PersistentValue` brings classes that can help you with value persistence. You can persist value in **UserDefaults** or **Keychain** with exactly the same simple interface. In which store is value stored is selected in initialization (every store has own `init`).

## Usage

###`PersistentValue` interface

`var value: ValueType?` — value that is persisted.

`func save()` — Saves current value synchronously into store.

`func fetch()` — Fetches value from store.

`func remove()` — Removes value from store.

### Examples

Enum helps avoid stringly typed api. Case is used instead of string identificator of value.

```swift
enum Key: String, CustomStringConvertible {
    case userName, password
    var description: String { return rawValue }
}
```

####UserDefaults

```swift
// Initial value
UserDefaults.standard.set("Tester", forKey: "userName")

// Initializes PersistentValue with UserDefaults store
let userName = PersistentString(key: Key.userName)

// prints: Tester
print(userName.value)

// Updates value (not saved in store)
userName.value = "SwiftNinja"

// Saves value in store
userName.save()

// Removes value from store
userName.remove()
```

####Keychain

```swift
// Saves 123456 into Keychain
PersistentString(value: "123456", account: Key.password).save()

// Reads '123456' from Keychain
PersistentString(account: Key.password).value
```

###Supported types in stores

Value can be stored right now in two destinations. In UserDefaults and in Keychain.

_DiskStore (save value into file at given path) is planned._

####UserDefaultsStore

UserDefaults is widely supported store. These types can be used for storing value in UserDefaults.

- PersistentBool
- PersistentCodable – whatever what can be encoded and decoded as **valid JSON**
- PersistentDouble
- PersistentFloat
- PersistentInt
- PersistentSet
- PersistentString
- PersistentURL
- PersistentDate

####KeychainStore

Keychain supports these types.

- PersistentBool
- PersistentCodable – whatever what can be encoded and decoded as **valid JSON**
- PersisntentString

---

**We are adding more types as we need them. Do you need something else? Let's contribute or at least create issue with your need.**

## Installation

### CocoaPods

Add `pod 'ETPersistentValue'` to your Podfile.

### Carthage

Add `github "EtneteraMobile/ETPersistentValue"` to your Cartfile.

## Contributing

Contributions to ETPersistentValue are welcomed and encouraged!

## License

ETPersistentValue is available under the MIT license. See [LICENSE](LICENSE) for more information.



