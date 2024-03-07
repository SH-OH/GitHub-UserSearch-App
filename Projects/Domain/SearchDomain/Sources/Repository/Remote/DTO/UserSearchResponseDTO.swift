//
//  UserSearchResponseDTO.swift
//  SearchDomain
//
//  Created by Oh Sangho on 2/21/24.
//  Copyright © 2024 com.shoh. All rights reserved.
//

import Foundation

import SearchDomainInterface

struct UserSearchResponseDTO: Decodable {
    let totalCount: Int?
    let incompleteResults: Bool?
    let items: [Item]
}

extension UserSearchResponseDTO {
    struct Item: Decodable {
        let login: String?
        let id: Int?
        let nodeId: String?
        let avatarUrl: String?
        let gravatarId: String?
        let url: String?
        let htmlUrl: String?
        let followersUrl: String?
        let followingUrl: String?
        let gistsUrl: String?
        let starredUrl: String?
        let subscriptionsUrl: String?
        let organizationsUrl: String?
        let reposUrl: String?
        let eventsUrl: String?
        let receivedEventsUrl: String?
        let type: String?
        let siteAdmin: Bool?
        let score: Double?
    }
}

extension UserSearchResponseDTO {
    func toDomain() throws -> [UserSearchModel] {
        try items.map({ try $0.toDomain() })
    }
}

extension UserSearchResponseDTO.Item {
    func toDomain() throws -> UserSearchModel {
        guard let id else {
            throw NSError(
                domain: "id Not Found - \(String(describing: id))",
                code: -1
            )
        }
        
        return .init(
            id: id,
            nickname: login ?? "",
            profileUrl: URL(string: avatarUrl ?? ""),
            isFavorited: false
        )
    }
}
