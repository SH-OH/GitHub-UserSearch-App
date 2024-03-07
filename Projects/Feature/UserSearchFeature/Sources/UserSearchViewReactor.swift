//
//  UserSearchViewReactor.swift
//  UserSearchFeature
//
//  Created by Oh Sangho on 2/21/24.
//  Copyright © 2024 com.shoh. All rights reserved.
//

import Foundation

import ReactorKit
import RxSwift
import RxRelay
import Kingfisher

import SearchDomainInterface
import GlobalThirdPartyLibrary
import FoundationUtility

final class UserSearchViewReactor: Reactor {
	
    enum Action: Equatable {
        case viewDidLoad
        case searchTextFieldDidEdit(_ keyword: String)
        case fetchUsersFromRemote
        case refresh
        case willDisplayCell(_ indexPath: IndexPath)
        case prefetchRows(_ indexPaths: [IndexPath])
        case cancelPrefetchingForRows(_ indexPaths: [IndexPath])
        case didTabChange
        case favoriteButtonDidTap(user: UserSearchModel, isFavorite: Bool)
	}
	
	enum Mutation {
        case setKeyword(String)
		case setUsers([UserSearchModel])
        case appendUsers([UserSearchModel])
        case setIsLoading(key: FetchType, value: Bool)
        case formUnionPrefetchedImageUrls(Set<URL>)
        case formUnionCanceledPrefetchImageUrls(Set<URL>)
		case setErrorMessage(String)
	}
	
	struct State {
        var keyword: String?
        var users: [UserSearchModel] = []
        var isLoadingMap: [FetchType: Bool] = [:]
        var prefetchedImageUrls: Set<URL> = .init()
        var canceledPrefetchImageUrls: Set<URL> = .init()
		@Pulse var errorMessage: String?
	}
    
    enum FetchType {
        case `default`
        case refresh
        case loadMore
    }
	
	let initialState: State
    
    private let searchUseCase: SearchUseCase
    private let searchEventBroker: SearchEventBroker
    private let favoritesDidUpdateRelay: PublishRelay<[UserSearchModel]> = .init()
    
    private var paginationState: PaginationState = .init()
    
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
    }
    
	func mutate(action: Action) -> Observable<Mutation> {
		switch action {
        case .viewDidLoad:
            searchUseCase.fetchFavoriteUsersFromLocalDB(keyword: nil)
            searchEventBroker.setUserDelegate(self)
            return .empty()
            
        case let .searchTextFieldDidEdit(keyword):
            return .just(.setKeyword(keyword))
            
        case .fetchUsersFromRemote, .refresh:
            let loadingType: FetchType = action == .refresh ? .refresh : .`default`
            
            return makeLoadingMutation(
                fetchUsers(with: loadingType),
                forKey: action == .refresh ? .refresh : .`default`
            )
            
        case let .willDisplayCell(indexPath):
            let paginationState = paginationState
            guard paginationState.shouldLoadNextPage(itemCount: currentState.users.count, at: indexPath) else {
                return .empty()
            }
            
            return makeLoadingMutation(
                fetchUsers(with: .loadMore),
                forKey: .loadMore
            )
            
        case let .prefetchRows(indexPaths):
            let users = currentState.users
            let prefetchedImageUrls = currentState.prefetchedImageUrls
            let prefetchTasks: [Observable<URL>] = indexPaths.map({ indexPath in
                return Observable<URL>.create { observer in
                    let disposables = Disposables.create {
                        observer.onCompleted()
                    }
                    
                    guard let url = users[safe: indexPath.row]?.profileUrl else { return disposables }
                    guard prefetchedImageUrls.contains(url) else { return disposables }
                    guard !ImageCache.default.isCached(forKey: url.absoluteString) else { return disposables }
                    
                    observer.onNext(url)
                    
                    return disposables
                }
            })
            
            return Observable.from(prefetchTasks)
                .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .utility))
                .mergeToArray()
                .map(Set.init)
                .map(Mutation.formUnionPrefetchedImageUrls)
               
        case let .cancelPrefetchingForRows(indexPaths):
            let users = currentState.users
            let canceledPrefetchImageUrls = currentState.canceledPrefetchImageUrls
            let cancelPrefetchingTasks: [Observable<URL>] = indexPaths.map({ indexPath in
                return Observable<URL>.create { observer in
                    let disposables = Disposables.create {
                        observer.onCompleted()
                    }
                    
                    guard let url = users[safe: indexPath.row]?.profileUrl else { return disposables }
                    guard canceledPrefetchImageUrls.contains(url) else { return disposables }
                    
                    observer.onNext(url)
                    
                    return disposables
                }
            })
            
            return Observable.from(cancelPrefetchingTasks)
                .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .utility))
                .mergeToArray()
                .map(Set.init)
                .map(Mutation.formUnionCanceledPrefetchImageUrls)
            
        case .didTabChange:
            return .just(.setUsers(currentState.users))
            
        case let .favoriteButtonDidTap(user, isFavorite):
            let prevUsers: [UserSearchModel] = currentState.users
            return searchUseCase.updateFavorite(for: user, isFavorited: isFavorite)
                .distinctUntilChanged()
                .do(onNext: { [searchEventBroker] in
                    searchEventBroker.didUpdateFromUserSearch(for: user.id, isFavorite: $0)
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
            
        case .appendUsers(let newValue):
            newState.users.append(contentsOf: newValue)
            
		case let .setIsLoading(key, newValue):
            newState.isLoadingMap[key] = newValue
            
        case .formUnionPrefetchedImageUrls(let newValue):
            newState.prefetchedImageUrls.formUnion(newValue)
            
        case .formUnionCanceledPrefetchImageUrls(let newValue):
            newState.canceledPrefetchImageUrls.formUnion(newValue)
            
		case .setErrorMessage(let newValue):
			newState.errorMessage = newValue
		}
		
		return newState
	}
}

extension UserSearchViewReactor: SearchEventBrokerDelegate {
    func favoritesDidUpdate(for userId: Int, isFavorite: Bool) {
        let updatedUsers = updateUser(id: userId, isFavorite: isFavorite)
        
        favoritesDidUpdateRelay.accept(updatedUsers)
    }
}

private extension UserSearchViewReactor {
    func updateUser(id: Int, isFavorite: Bool) -> [UserSearchModel] {
        var newUsers = currentState.users
        
        if let index = newUsers.firstIndex(where: { $0.id == id }) {
            var newUser = newUsers[index]
            newUser.isFavorited = isFavorite
            newUsers[index] = newUser
        }
        
        return newUsers
    }
    
    func fetchUsers(with loadingType: FetchType) -> Observable<Mutation> {
        guard let keyword = currentState.keyword, !keyword.isEmpty else {
            return .just(.setUsers([]))
        }
        
        let prevPaginationState = paginationState
        
        let startPaginationState: PaginationState = loadingType == .loadMore
        ? prevPaginationState.prepareNextPage()
        : prevPaginationState.reset()
        
        self.paginationState = startPaginationState
        
        return makeLoadingMutation(
            searchUseCase.fetchUsersFromRemote(
                keyword: keyword,
                paginationState: startPaginationState
            )
            .asObservable()
            .map({ loadingType == .loadMore ? .appendUsers($0) : .setUsers($0) }),
            forKey: loadingType
        )
        .do(onNext: { [weak self] _ in
            self?.paginationState = startPaginationState.finish()
        }, onError: { [weak self] _ in
            self?.paginationState = prevPaginationState
        })
    }
    
    func makeLoadingMutation(
        _ mutationEvent: Observable<Mutation>,
        forKey type: FetchType
    ) -> Observable<Mutation> {
        return .concat(
            type == .loadMore ? .empty() : .just(.setIsLoading(key: type, value: true)),
            mutationEvent,
            type == .loadMore ? .empty() : .just(.setIsLoading(key: type, value: false))
        )
        .catch({ error -> Observable<Mutation> in
            return .just(.setErrorMessage(error.localizedDescription))
                .merge(with: .just(.setIsLoading(key: type, value: false)))
        })
    }
}

private extension ObservableType where Element: ObservableConvertibleType {
    func mergeToArray() -> Observable<[Element.Element]> {
        return self
            .merge()
            .toArray()
            .asObservable()
    }
}
