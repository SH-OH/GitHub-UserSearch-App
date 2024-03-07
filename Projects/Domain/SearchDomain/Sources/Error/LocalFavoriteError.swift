//
//  LocalFavoriteError.swift
//  SearchDomain
//
//  Created by Oh Sangho on 2/23/24.
//  Copyright © 2024 com.shoh.app. All rights reserved.
//

import Foundation

import SearchDomainInterface

enum LocalFavoriteError: Error {
    case addFailure(Error)
    case removeFailure(userId: Int)
}

extension LocalFavoriteError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .addFailure(let error):
            return "Add Failure - \(error)"
        case .removeFailure(let userId):
            return "Remove Failure - Not found userId: \(userId)"
        }
    }
}
