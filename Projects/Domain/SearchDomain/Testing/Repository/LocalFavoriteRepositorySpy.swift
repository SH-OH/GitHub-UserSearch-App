//
//  LocalFavoriteRepositorySpy.swift
//  SearchDomainTesting
//
//  Created by Oh Sangho on 2/27/24.
//  Copyright © 2024 com.shoh.app. All rights reserved.
//

import Foundation
import SearchDomainInterface

final class LocalFavoriteRepositorySpy: LocalFavoriteRepository {
    var fetchFavoritedUsersCallCount: Int = 0
    var fetchFavoritedUsersReturn: [UserSearchModel] = []
    func fetchFavoritedUsers(keyword: String?) async -> [UserSearchModel] {
        fetchFavoritedUsersCallCount += 1
        return fetchFavoritedUsersReturn
    }
    
    var addToFavoritesCallCount: Int = 0
    func addToFavorites(user: UserSearchModel) async throws {
        addToFavoritesCallCount += 1
    }
    
    var removeFromFavoritesCallCount: Int = 0
    func removeFromFavorites(userId: Int) async throws {
        removeFromFavoritesCallCount += 1
    }
    
    func synchronize() {}
}
