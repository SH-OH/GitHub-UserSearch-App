//
//  SearchTarget.swift
//  SearchDomain
//
//  Created by Oh Sangho on 2/21/24.
//  Copyright © 2024 com.shoh. All rights reserved.
//

import Foundation

import NetworkingInterface

public enum SearchTarget {
    case fetchSearchedUsers(keyword: String, page: Int, perPage: Int)
}

extension SearchTarget: TargetType {
    
    public var path: String {
        switch self {
        case .fetchSearchedUsers:
            return "/search/users"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .fetchSearchedUsers:
            return .get
        }
    }
    
    public var parameters: Parameters? {
        switch self {
        case let .fetchSearchedUsers(keyword, page, perPage):
            return [
                "q": keyword,
                "page": page,
                "per_page": perPage
            ]
        }
    }
    
    public var headers: Headers? {
        switch self {
        case .fetchSearchedUsers:
            return nil
        }
    }
    
    public var errorMap: [Int : Error] {
        UserSearchError.toErrorMap()
    }
}
