//
//  SearchUseCaseTests.swift
//  SearchDomainTests
//
//  Created by Oh Sangho on 2/27/24.
//  Copyright © 2024 com.shoh.app. All rights reserved.
//

import XCTest

import RxSwift

import SearchDomainInterface
@testable import SearchDomain
@testable import SearchDomainTesting

final class SearchUseCaseTests: XCTestCase {
    var remoteSearchRepository: RemoteSearchRepositorySpy!
    var localFavoriteRepository: LocalFavoriteRepositorySpy!
    var memoryCache: MemoryCache!
    var sut: SearchUseCaseImpl!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        remoteSearchRepository = .init()
        localFavoriteRepository = .init()
        memoryCache = .init()
        sut = .init(
            searchRepository: remoteSearchRepository,
            favoriteRepository: localFavoriteRepository,
            memoryCache: memoryCache
        )
        disposeBag = .init()
    }

    override func tearDownWithError() throws {
        remoteSearchRepository = nil
        localFavoriteRepository = nil
        memoryCache = nil
        sut = nil
        disposeBag = nil
    }
    
    func test_fetchUsersFromRemote() async throws {
        // given
        XCTAssertEqual(remoteSearchRepository.fetchSearchedUsersCallCount, 0)
        let isEmptyFavoriteState = await memoryCache.favoriteState.isEmpty
        XCTAssertEqual(isEmptyFavoriteState, true)
        
        let expectation = XCTestExpectation(description: "test_fetchUsersFromRemote expectation")
        let expected: [UserSearchModel] = [
            .init(
                id: 100,
                nickname: "Github",
                profileUrl: nil,
                isFavorited: false
            ),
            .init(
                id: 200,
                nickname: "CachedGithub",
                profileUrl: nil,
                isFavorited: false
            )
        ]
        await memoryCache.update(isFavorite: true, forKey: expected[1].id)
        remoteSearchRepository.fetchSearchedUsersReturn = expected
        
        // when
        let fetchUsersFromRemote = sut.fetchUsersFromRemote(
            keyword: "",
            paginationState: .init()
        )
        var eventCount: Int = 0
        fetchUsersFromRemote
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { result in
                // then
                XCTAssertEqual(eventCount, 0)
                eventCount += 1
                XCTAssertEqual(self.remoteSearchRepository.fetchSearchedUsersCallCount, 1)
                
                XCTAssertEqual(result[0], expected[0])
                XCTAssertEqual(result[1].id, expected[1].id)
                XCTAssertEqual(result[1].nickname, expected[1].nickname)
                XCTAssertEqual(result[1].profileUrl, expected[1].profileUrl)
                XCTAssertEqual(result[1].isFavorited, !expected[1].isFavorited)
                
                expectation.fulfill()
            }, onFailure: { error in
                XCTFail("Failed test_fetchUsersFromRemote")
            })
            .disposed(by: disposeBag)
        
        await fulfillment(of: [expectation])
    }
    
    func test_fetchFavoriteUsersFromLocalDB() async throws {
        // given
        XCTAssertEqual(localFavoriteRepository.fetchFavoritedUsersCallCount, 0)
        XCTAssertEqual(localFavoriteRepository.fetchFavoritedUsersReturn, [])
        let isEmptyFavoriteState = await memoryCache.favoriteState.isEmpty
        XCTAssertEqual(isEmptyFavoriteState, true)
        
        let expectation = XCTestExpectation(description: "test_fetchFavoriteUsersFromLocalDB expectation")
        let expected: [UserSearchModel] = [
            .init(
                id: 100,
                nickname: "Github",
                profileUrl: nil,
                isFavorited: false
            ),
            .init(
                id: 200,
                nickname: "CachedGithub",
                profileUrl: nil,
                isFavorited: true
            )
        ]
        localFavoriteRepository.fetchFavoritedUsersReturn = expected.filter(\.isFavorited)
        
        // when
        let fetchFavoriteUsersFromLocalDB = sut.fetchFavoriteUsersFromLocalDB(keyword: "")
        var eventCount: Int = 0
        fetchFavoriteUsersFromLocalDB
            .asObservable()
            .observe(on: MainScheduler.instance)
            .bind(onNext: { result in
                // then
                XCTAssertEqual(eventCount, 0)
                eventCount += 1
                XCTAssertEqual(self.localFavoriteRepository.fetchFavoritedUsersCallCount, 1)
                
                XCTAssertEqual(result[0], expected[1])
                
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        await fulfillment(of: [expectation])
    }
    
    func test_addToFavorites() async throws {
        // given
        XCTAssertEqual(localFavoriteRepository.addToFavoritesCallCount, 0)
        let isEmptyFavoriteState = await memoryCache.favoriteState.isEmpty
        XCTAssertEqual(isEmptyFavoriteState, true)
        
        let expectation = XCTestExpectation(description: "test_addToFavorites expectation")
        let mockModel: UserSearchModel = .init(
            id: 100,
            nickname: "Github",
            profileUrl: nil,
            isFavorited: false
        )
        let expected = true
        
        // when
        let updateFavorite = sut.updateFavorite(for: mockModel, isFavorited: expected)
        updateFavorite
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
                // then
                XCTAssertEqual(self.localFavoriteRepository.addToFavoritesCallCount, 1)
                
                XCTAssertEqual(result, expected)
                
                expectation.fulfill()
            }, onError: { error in
                XCTFail("Failed test_addToFavorites")
            })
            .disposed(by: disposeBag)
        
        await fulfillment(of: [expectation])
    }
    
    func test_removeFromFavorites() async throws {
        // given
        XCTAssertEqual(localFavoriteRepository.removeFromFavoritesCallCount, 0)
        let isEmptyFavoriteState = await memoryCache.favoriteState.isEmpty
        XCTAssertEqual(isEmptyFavoriteState, true)
        
        let expectation = XCTestExpectation(description: "test_removeFromFavorites expectation")
        let mockModel: UserSearchModel = .init(
            id: 100,
            nickname: "Github",
            profileUrl: nil,
            isFavorited: true
        )
        let expected = false
        
        // when
        let updateFavorite = sut.updateFavorite(for: mockModel, isFavorited: expected)
        updateFavorite
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
                // then
                XCTAssertEqual(self.localFavoriteRepository.removeFromFavoritesCallCount, 1)
                
                XCTAssertEqual(result, expected)
                
                expectation.fulfill()
            }, onError: { error in
                XCTFail("Failed test_removeFromFavorites")
            })
            .disposed(by: disposeBag)
        
        await fulfillment(of: [expectation])
    }
}
