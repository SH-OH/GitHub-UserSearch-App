//
//  SearchUseCase.swift
//  SearchDomainInterface
//
//  Created by Oh Sangho on 2/21/24.
//  Copyright © 2024 com.shoh. All rights reserved.
//

import Foundation

import RxSwift

public protocol SearchUseCase {
    func fetchUsersFromRemote(keyword: String, paginationState: PaginationState) -> Single<[UserSearchModel]>
    @discardableResult
    func fetchFavoriteUsersFromLocalDB(keyword: String?) -> Infallible<[UserSearchModel]>
    func updateFavorite(for user: UserSearchModel, isFavorited: Bool) -> Observable<Bool>
    func synchronizeLocalDB()
}
