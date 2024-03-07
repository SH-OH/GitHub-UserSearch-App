//
//  UserSearchError.swift
//  SearchDomain
//
//  Created by Oh Sangho on 2/23/24.
//  Copyright © 2024 com.shoh.app. All rights reserved.
//

import Foundation

import BaseDomainInterface

enum UserSearchError: Int, DomainError {
    case notModified = 304
    case apiRateLimitExceeded = 403
    case validationFailedOrEndpointHasBeenSpammed = 422
    case serviceUnavailable = 503
}

extension UserSearchError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .notModified:
            return "Not modified"
        case .apiRateLimitExceeded:
            return "API rate limit exceeded for your IP. (But here's the good news: Authenticated requests get a higher rate limit. Check out the documentation for more details.)"
        case .validationFailedOrEndpointHasBeenSpammed:
            return "Validation failed, or the endpoint has been spammed."
        case .serviceUnavailable:
            return "Service unavailable"
        }
    }
}
