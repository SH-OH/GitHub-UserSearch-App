//
//  SearchDomainAssembly.swift
//  SearchDomain
//
//  Created by Oh Sangho on 2/21/24.
//  Copyright © 2024 com.shoh. All rights reserved.
//

import Foundation
import CoreData

import Swinject

import DatabaseInterface
import SearchDomainInterface
import NetworkingInterface
import GlobalThirdPartyLibrary

public final class SearchDomainAssembly: Assembly {
    
    public init() {}
    
    public func assemble(container: Container) {
        container.register(RemoteSearchRepository.self) { r in
            RemoteSearchRepositoryImpl(
                networkService: r.resolve(NetworkService.self)
            )
        }
        .inObjectScope(.container)
        container.register(LocalFavoriteRepository.self) { r in
            let name: String = "User"
            guard let modelURL = Bundle.module.url(forResource: name, withExtension: "momd") else {
                fatalError("Failed to locate CoreData model in bundle")
            }
            guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
                fatalError("Failed to load CoreData model")
            }
            
            return LocalFavoriteRepositoryImpl(
                localDBService: r.resolve(LocalDBService.self, arguments: name, model)
            )
        }
        .inObjectScope(.container)
        container.register(MemoryCache.self) { _ in
            MemoryCache.init()
        }
        .inObjectScope(.container)
        
        container.register(SearchUseCase.self) { r in
            SearchUseCaseImpl(
                searchRepository: r.resolve(RemoteSearchRepository.self), 
                favoriteRepository: r.resolve(LocalFavoriteRepository.self),
                memoryCache: r.resolve(MemoryCache.self)
            )
        }
        
        container.register(SearchEventBroker.self) { _ in
            SearchEventBrokerImpl()
        }
    }
}
