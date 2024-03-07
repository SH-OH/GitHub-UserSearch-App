//
//  FavoriteUser+CoreDataClass.swift
//  SearchDomain
//
//  Created by Oh Sangho on 2/22/24.
//  Copyright © 2024 com.shoh.app. All rights reserved.
//
//

import Foundation
import CoreData

import SearchDomainInterface

@objc(FavoriteUser)
final class FavoriteUser: NSManagedObject {}

extension FavoriteUser {
    convenience init(context: NSManagedObjectContext, user: UserSearchModel) {
        self.init(context: context)
        
        self.userId = Int64(user.id)
        self.nickname = user.nickname
        self.profileUrl = user.profileUrl
        self.isFavorited = user.isFavorited
    }
}

extension FavoriteUser {
    func toDomain() -> UserSearchModel {
        .init(
            id: Int(userId),
            nickname: nickname ?? "",
            profileUrl: profileUrl,
            isFavorited: isFavorited
        )
    }
}

extension NSManagedObject {
    convenience init(context: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        let entity = NSEntityDescription.entity(forEntityName: name, in: context)!
        self.init(entity: entity, insertInto: context)
    }
}

