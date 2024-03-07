//
//  UserSearchModel.swift
//  SearchDomainInterface
//
//  Created by Oh Sangho on 2/21/24.
//  Copyright © 2024 com.shoh. All rights reserved.
//

import Foundation

public struct UserSearchModel: Hashable {
    public let id: Int
    public let nickname: String
    public let profileUrl: URL?
    public var isFavorited: Bool
    
    public init(
        id: Int,
        nickname: String,
        profileUrl: URL?,
        isFavorited: Bool
    ) {
        self.id = id
        self.nickname = nickname
        self.profileUrl = profileUrl
        self.isFavorited = isFavorited
    }
}
