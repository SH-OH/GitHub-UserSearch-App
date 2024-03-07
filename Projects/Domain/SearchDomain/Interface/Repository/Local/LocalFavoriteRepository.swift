//
//  LocalFavoriteRepository.swift
//  SearchDomainInterface
//
//  Created by Oh Sangho on 2/22/24.
//  Copyright © 2024 com.shoh.app. All rights reserved.
//

import Foundation

public protocol LocalFavoriteRepository {
    func fetchFavoritedUsers(keyword: String?) async -> [UserSearchModel]
    func addToFavorites(user: UserSearchModel) async throws
    func removeFromFavorites(userId: Int) async throws
    func synchronize()
}
