//
//  RemoteSearchRepositoryImpl.swift
//  SearchDomain
//
//  Created by Oh Sangho on 2/21/24.
//  Copyright © 2024 com.shoh. All rights reserved.
//

import Foundation

import NetworkingInterface
import SearchDomainInterface

final class RemoteSearchRepositoryImpl: RemoteSearchRepository {
    
    private let networkService: any NetworkService
    
    init(networkService: any NetworkService) {
        self.networkService = networkService
    }
    
    func fetchSearchedUsers(keyword: String, page: Int, perPage: Int) async throws -> [UserSearchModel] {
        let keywordOnlyUserLogin = keyword + "+type:user" + "+in:login"
        let dto: UserSearchResponseDTO = try await networkService.request(
            target: SearchTarget.fetchSearchedUsers(
                keyword: keywordOnlyUserLogin,
                page: page,
                perPage: perPage
            )
        )
        
        return try dto.toDomain()
    }
}
