//
//  String+Ext.swift
//  FoundationUtility
//
//  Created by Oh Sangho on 2/25/24.
//  Copyright © 2024 com.shoh.app. All rights reserved.
//

import Foundation

public extension String {
    var isHangul: Bool {
        hasMatchedToPropertyValue("Hangul")
    }
    var isLatin: Bool {
        hasMatchedToPropertyValue("Latin")
    }
    
    func hasMatchedToPropertyValue(_ unicodePropertyValue: String) -> Bool {
        return self.range(
            of: "\\p{\(unicodePropertyValue)}",
            options: .regularExpression
        ) != nil
    }
}
