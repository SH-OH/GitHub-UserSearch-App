//
//  DomainError.swift
//  BaseDomainInterface
//
//  Created by Oh Sangho on 2/23/24.
//  Copyright © 2024 com.shoh.app. All rights reserved.
//

import Foundation

public protocol DomainError: Error, CaseIterable, RawRepresentable<Int> {}

extension DomainError {
    public static func toErrorMap() -> [Int: Error] {
        return allCases.reduce(into: [Int: Error](), { $0[$1.rawValue] = $1 })
    }
}
