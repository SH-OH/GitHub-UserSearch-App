//
//  SearchUseCaseSpy.swift
//  SearchDomainTesting
//
//  Created by Oh Sangho on 2/27/24.
//  Copyright © 2024 com.shoh.app. All rights reserved.
//

import Foundation

import RxSwift

import SearchDomainInterface

final class SearchUseCaseSpy: SearchUseCase {
    var fetchUsersFromRemoteCallCount: Int = 0
    var fetchUsersFromRemoteReturn: [UserSearchModel] = []
    func fetchUsersFromRemote(keyword: String, paginationState: PaginationState) -> Single<[UserSearchModel]> {
        fetchUsersFromRemoteCallCount += 1
        return .just(fetchUsersFromRemoteReturn)
            .delay(.seconds(1), scheduler: MainScheduler.asyncInstance)
    }
    
    var fetchFavoriteUsersFromLocalDBCallCount: Int = 0
    var fetchFavoriteUsersFromLocalDBReturn: [UserSearchModel] = []
    func fetchFavoriteUsersFromLocalDB(keyword: String?) -> Infallible<[UserSearchModel]> {
        fetchFavoriteUsersFromLocalDBCallCount += 1
        return .just(fetchFavoriteUsersFromLocalDBReturn)
            .asObservable()
            .delay(.milliseconds(500), scheduler: MainScheduler.asyncInstance)
            .asInfallible(onErrorFallbackTo: .just([]))
    }
    
    var updateFavoriteCallCount: Int = 0
    func updateFavorite(for user: UserSearchModel, isFavorited: Bool) -> Observable<Bool> {
        updateFavoriteCallCount += 1
        return .just(isFavorited)
            .observe(on: MainScheduler.asyncInstance)
    }
    
    var synchronizeLocalDBCallCount: Int = 0
    func synchronizeLocalDB() {
        synchronizeLocalDBCallCount += 1
    }
}
