//
//  SearchUseCaseImpl.swift
//  SearchDomain
//
//  Created by Oh Sangho on 2/21/24.
//  Copyright © 2024 com.shoh. All rights reserved.
//

import Foundation

import RxSwift

import SearchDomainInterface
import ConcurrencyUtility
import GlobalThirdPartyLibrary

struct SearchUseCaseImpl: SearchUseCase {
    
    private let searchRepository: any RemoteSearchRepository
    private let favoriteRepository: any LocalFavoriteRepository
    private let memoryCache: MemoryCache
    private let searchEventBroker: SearchEventBrokerImpl = .init()
    
    init(
        searchRepository: any RemoteSearchRepository,
        favoriteRepository: any LocalFavoriteRepository,
        memoryCache: MemoryCache
    ) {
        self.searchRepository = searchRepository
        self.favoriteRepository = favoriteRepository
        self.memoryCache = memoryCache
    }
    
    func fetchUsersFromRemote(
        keyword: String,
        paginationState: PaginationState
    ) -> Single<[UserSearchModel]> {
        return Single<[UserSearchModel]>.create { observer in
            let task = Task(priority: .userInitiated) {
                do {
                    try Task.checkCancellation()
                    var users = try await searchRepository.fetchSearchedUsers(
                        keyword: keyword,
                        page: paginationState.currentPage,
                        perPage: paginationState.perPage
                    )
                    try Task.checkCancellation()
                    for (index, var user) in users.enumerated() {
                        let isFavorited = await memoryCache.isFavorite(userId: user.id)
                        
                        if isFavorited {
                            user.isFavorited = isFavorited
                            users[index] = user
                        }
                    }
                    
                    observer(.success(users))
                } catch {
                    print(error)
                    observer(.failure(error))
                }
            }
            return Disposables.create(with: task.cancel)
        }
    }
    
    @discardableResult
    func fetchFavoriteUsersFromLocalDB(keyword: String?) -> Infallible<[UserSearchModel]> {
        return Infallible<[UserSearchModel]>.create { observer in
            let task = Task(priority: .userInitiated) {
                try Task.checkCancellation()
                let users = await favoriteRepository.fetchFavoritedUsers(keyword: keyword)
                try Task.checkCancellation()
                let favoriteState = users.reduce(into: [Int: Bool](), { $0[$1.id] = $1.isFavorited })
                
                await memoryCache.updateFavorites(with: favoriteState)
                
                observer(.next(users))
                observer(.completed)
            }
            return Disposables.create(with: task.cancel)
        }
    }
    
    func updateFavorite(for user: UserSearchModel, isFavorited: Bool) -> Observable<Bool> {
        Observable.merge(
            updateFavoriteInMemoryCache(for: user, isFavorited: isFavorited).asObservable(),
            updateFavoriteInLocalDB(for: user, isFavorited: isFavorited).asObservable()
        )
    }
    
    func synchronizeLocalDB() {
        favoriteRepository.synchronize()
    }
}

private extension SearchUseCaseImpl {
    func updateFavoriteInMemoryCache(for user: UserSearchModel, isFavorited: Bool) -> Infallible<Bool> {
        Infallible<Bool>.create { observer in
            Task { @MainActor in
                await memoryCache.update(isFavorite: isFavorited, forKey: user.id)
                
                observer(.next(isFavorited))
                observer(.completed)
            }
            return Disposables.create()
        }
    }
    
    func updateFavoriteInLocalDB(for user: UserSearchModel, isFavorited: Bool) -> Single<Bool> {
        Single<Bool>.create { observer in
            let task = Task(priority: .userInitiated) {
                do {
                    try Task.checkCancellation()
                    if isFavorited {
                        try await favoriteRepository.addToFavorites(user: user)
                    } else {
                        try await favoriteRepository.removeFromFavorites(userId: user.id)
                    }
                    try Task.checkCancellation()
                    observer(.success(isFavorited))
                } catch {
                    observer(.failure(error))
                }
            }
            return Disposables.create(with: task.cancel)
        }
    }
}
