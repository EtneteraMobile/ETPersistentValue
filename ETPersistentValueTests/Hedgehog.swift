//
//  Hedgehog.swift
//  ETPersistentValueTests
//
//  Created by Jan Kodeš on 17/08/2018.
//

import Foundation

/// Struct for testing Codable capabilities
struct Hedgehog: Codable, Equatable {
    
    var name: String
    var alive: Bool
    var sex: Sex
    var friends: [Hedgehog]?
    var birthday: Date
    
    enum Sex: Int, Codable {
        case male
        case female
    }
    
    static let carlos = Hedgehog(name: "Speedy Carlos", alive: false, sex: .male, friends: nil, birthday: Date(timeIntervalSinceReferenceDate: -123456789.0))
    static let anna = Hedgehog(name: "Swifty Anna", alive: true, sex: .female, friends: [carlos], birthday: Date(timeIntervalSinceReferenceDate: -123456789.0))
    
}
