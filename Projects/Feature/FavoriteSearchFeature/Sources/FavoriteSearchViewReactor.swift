//
//  FavoriteSearchViewReactor.swift
//  FavoriteSearchFeature
//
//  Created by Oh Sangho on 2/23/24.
//  Copyright © 2024 com.shoh.app. All rights reserved.
//

import Foundation

import ReactorKit
import RxSwift
import RxRelay

import SearchDomainInterface
import GlobalThirdPartyLibrary
import FoundationUtility

final class FavoriteSearchViewReactor: Reactor {
    
    enum Action: Equatable {
        case viewDidLoad
        case searchTextFieldDidEdit(keyword: String)
        case fetchFavoriteUsersFromLocalDB
        case refresh
        case favoriteButtonDidTap(user: UserSearchModel, isFavorite: Bool)
    }
    
    enum Mutation {
        case setKeyword(String)
        case setUsers([UserSearchModel])
        case setIsLoading(key: FetchType, value: Bool)
        case setErrorMessage(String)
    }
    
    struct State {
        var keyword: String?
        @Pulse var users: [UserSearchModel] = []
        var isLoadingMap: [FetchType: Bool] = [:]
        @Pulse var errorMessage: String?
    }
    
    enum FetchType {
        case `default`
        case refresh
    }
    
    let initialState: State
    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .default)
    
    private let searchUseCase: SearchUseCase
    private let searchEventBroker: SearchEventBroker
    private let favoritesDidUpdateRelay: PublishRelay<[UserSearchModel]> = .init()
    
    init(
        searchUseCase: any SearchUseCase,
        searchEventBroker: any SearchEventBroker
    ) {
        initialState = .init()
        self.searchUseCase = searchUseCase
        self.searchEventBroker = searchEventBroker
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        mutation
            .merge(with: favoritesDidUpdateRelay.map(Mutation.setUsers))
            .catch({ error -> Observable<Mutation> in
                return .just(.setErrorMessage(error.localizedDescription))
            })
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            searchEventBroker.setFavoriteDelegate(self)
            
            return makeLoadingMutation(
                searchUseCase.fetchFavoriteUsersFromLocalDB(keyword: nil)
                    .asObservable()
                    .map(Mutation.setUsers), 
                forKey: .default
            )
            
        case let .searchTextFieldDidEdit(keyword):
            return .just(.setKeyword(keyword))
            
        case .fetchFavoriteUsersFromLocalDB, .refresh:
            let loadingType: FetchType = action == .refresh ? .refresh : .`default`
            
            return makeLoadingMutation(
                searchUseCase.fetchFavoriteUsersFromLocalDB(keyword: currentState.keyword)
                    .asObservable()
                    .map(Mutation.setUsers), 
                forKey: loadingType
            )
            
        case let .favoriteButtonDidTap(user, isFavorite):
            let prevUsers: [UserSearchModel] = currentState.users
            return searchUseCase.updateFavorite(for: user, isFavorited: isFavorite)
                .distinctUntilChanged()
                .do(onNext: { [searchEventBroker] in
                    searchEventBroker.didUpdateFromFavoriteSearch(for: user.id, isFavorite: $0)
                }, onError: { [searchEventBroker] _ in
                    searchEventBroker.didUpdateFromFavoriteSearch(for: user.id, isFavorite: !isFavorite)
                })
                .compactMap({ [weak self] isFavorite -> Mutation? in
                    guard let updatedUsers = self?.updateUser(id: user.id, isFavorite: isFavorite) else {
                        return nil
                    }
                    return Mutation.setUsers(updatedUsers)
                })
                .catch({ error in
                    return .just(.setUsers(prevUsers))
                })
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState: State = state
        
        switch mutation {
        case .setKeyword(let newValue):
            newState.keyword = newValue
            
        case .setUsers(let newValue):
            newState.users = newValue
            
        case let .setIsLoading(key, newValue):
            newState.isLoadingMap[key] = newValue
            
        case .setErrorMessage(let newValue):
            newState.errorMessage = newValue
        }
        
        return newState
    }
}

extension FavoriteSearchViewReactor: SearchEventBrokerDelegate {
    func favoritesDidUpdate(for userId: Int, isFavorite: Bool) {
        let updatedUsers = updateUser(id: userId, isFavorite: isFavorite)
        
        favoritesDidUpdateRelay.accept(updatedUsers)
    }
}

private extension FavoriteSearchViewReactor {
    func updateUser(id: Int, isFavorite: Bool) -> [UserSearchModel] {
        var newUsers = currentState.users
        
        if let index = newUsers.firstIndex(where: { $0.id == id }) {
            var newUser = newUsers[index]
            newUser.isFavorited = isFavorite
            newUsers[index] = newUser
        }
        
        return newUsers
    }
    
    func makeLoadingMutation(
        _ mutationEvent: Observable<Mutation>,
        forKey type: FetchType
    ) -> Observable<Mutation> {
        return .concat(
            .just(.setIsLoading(key: type, value: true)),
            mutationEvent,
            .just(.setIsLoading(key: type, value: false))
        )
        .catch({ error -> Observable<Mutation> in
            return .just(.setErrorMessage(error.localizedDescription))
                .merge(with: .just(.setIsLoading(key: type, value: false)))
        })
    }
}
