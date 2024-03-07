//
//  RemoteSearchRepository.swift
//  SearchDomainInterface
//
//  Created by Oh Sangho on 2/21/24.
//  Copyright © 2024 com.shoh. All rights reserved.
//

import Foundation

public protocol RemoteSearchRepository {
    func fetchSearchedUsers(keyword: String, page: Int, perPage: Int) async throws -> [UserSearchModel]
}
