//
//  LocalFavoriteRepositoryImpl.swift
//  SearchDomain
//
//  Created by Oh Sangho on 2/22/24.
//  Copyright © 2024 com.shoh.app. All rights reserved.
//

import Foundation

import DatabaseInterface
import SearchDomainInterface

final class LocalFavoriteRepositoryImpl: LocalFavoriteRepository {
    
    typealias Entity = FavoriteUser
    typealias Model = UserSearchModel
    
    private let localDBService: any LocalDBService
    
    init(localDBService: any LocalDBService) {
        self.localDBService = localDBService
    }
    
    func fetchFavoritedUsers(keyword: String?) async -> [Model] {
        let predicate: NSPredicate
        let sortDescriptor: NSSortDescriptor = .init(
            key: #keyPath(Entity.nickname),
            ascending: true,
            selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
        )
        
        if let keyword, !keyword.isEmpty {
            predicate = .init(
                format: "%K == %@ && %K CONTAINS[c] %@",
                #keyPath(Entity.isFavorited),
                NSNumber(value: true),
                #keyPath(Entity.nickname),
                keyword
            )
        } else {
            predicate = .init(
                format: "%K == %@",
                #keyPath(Entity.isFavorited),
                NSNumber(value: true)
            )
        }
        
        let entities: [Entity] = await localDBService.read(predicate: predicate, sortDescriptors: [sortDescriptor])
        
        return entities.map({ $0.toDomain() })
    }
    
    func addToFavorites(user: Model) async throws {
        let context = localDBService.childbackgroundContext
        let fetchUser = FavoriteUser.fetchRequest()
        fetchUser.predicate = .init(
            format: "%K == %d",
            #keyPath(Entity.userId),
            user.id
        )
        
        let updateUser = try context.fetch(fetchUser).first ?? FavoriteUser(
            context: context,
            user: user
        )
        updateUser.isFavorited = true
        
        do {
            try await self.localDBService.update(entity: updateUser)
        } catch {
            throw LocalFavoriteError.addFailure(error)
        }
    }
    
    func removeFromFavorites(userId: Int) async throws {
        let context = localDBService.childbackgroundContext
        let fetchUser = FavoriteUser.fetchRequest()
        fetchUser.predicate = .init(
            format: "%K == %d",
            #keyPath(Entity.userId),
            userId
        )
        
        guard let user = try context.fetch(fetchUser).first else {
            throw LocalFavoriteError.removeFailure(userId: userId)
        }
        user.isFavorited = false
        
        try await self.localDBService.update(entity: user)
    }
    
    func synchronize() {
        Task(priority: .background) {
            let predicate = NSPredicate(
                format: "%K == %@",
                #keyPath(Entity.isFavorited),
                NSNumber(value: false)
            )
            let entities: [Entity] = await localDBService.read(predicate: predicate, sortDescriptors: [])
            
            for entity in entities {
                try await localDBService.delete(entity: entity)
            }
        }
    }
}
