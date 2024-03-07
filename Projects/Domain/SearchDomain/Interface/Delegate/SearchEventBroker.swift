//
//  SearchEventBroker.swift
//  SearchDomainInterface
//
//  Created by Oh Sangho on 2/24/24.
//  Copyright © 2024 com.shoh.app. All rights reserved.
//

import Foundation

// SearchDomain을 사용하는 특정 Feature 사이의 이벤트 중개 class
/// UserSearchFeature, FavoriteSearchFeature
public protocol SearchEventBroker {
    func setUserDelegate(_ delegate: any SearchEventBrokerDelegate)
    func setFavoriteDelegate(_ delegate: any SearchEventBrokerDelegate)
    func didUpdateFromUserSearch(for userId: Int, isFavorite: Bool)
    func didUpdateFromFavoriteSearch(for userId: Int, isFavorite: Bool)
}
