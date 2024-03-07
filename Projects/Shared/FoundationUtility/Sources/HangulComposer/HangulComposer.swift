//
//  HangulComposer.swift
//  FoundationUtility
//
//  Created by Oh Sangho on 2/25/24.
//  Copyright © 2024 com.shoh.app. All rights reserved.
//

import Foundation

public enum HangulComposer {
    case initialConsonant
    case medialVowel
    case finalConsonant
    
    public var list: [String] {
        switch self {
        case .initialConsonant:
            guard let startUnicodeScalar = UnicodeScalar(Self.startInitialConsonantUnicode) else {
                return []
            }
            
            return (startUnicodeScalar.value..<startUnicodeScalar.value + Self.countOfInitialConsonant)
                .asStrings
        default:
            return []
        }
    }
    
    public func extractHangulInitialConsonant(char: String) -> String? {
        guard let charUnicode = char.unicodeScalars.first?.value else { return nil }
        
        let index = Int((Int(charUnicode) - Self.unicode_ㄱ) / 28 / 21)
        let list = Self.initialConsonant.list
        return list.count > index ? list[index] : nil
    }
}

private extension HangulComposer {
    static let startInitialConsonantUnicode: Int = 0x1100
    
    static let countOfInitialConsonant: UInt32 = 19
    
    static let unicode_ㄱ: Int = 0xAC00
}

extension Range<UInt32> {
    var asStrings: [String] {
        self.map({ String($0, radix: 16) })
            .compactMap({ UnicodeScalar(Int($0, radix: 16) ?? 0) })
            .map(String.init)
    }
}
