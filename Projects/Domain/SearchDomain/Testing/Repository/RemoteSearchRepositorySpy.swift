//
//  RemoteSearchRepositorySpy.swift
//  SearchDomainTesting
//
//  Created by Oh Sangho on 2/27/24.
//  Copyright © 2024 com.shoh.app. All rights reserved.
//

import Foundation
import SearchDomainInterface

final class RemoteSearchRepositorySpy: RemoteSearchRepository {
    var fetchSearchedUsersCallCount: Int = 0
    var fetchSearchedUsersReturn: [UserSearchModel] = []
    func fetchSearchedUsers(keyword: String, page: Int, perPage: Int) async throws -> [UserSearchModel] {
        fetchSearchedUsersCallCount += 1
        return fetchSearchedUsersReturn
    }
}
