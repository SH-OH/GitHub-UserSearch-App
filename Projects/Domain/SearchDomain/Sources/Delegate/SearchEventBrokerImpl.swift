//
//  SearchEventBrokerImpl.swift
//  SearchDomain
//
//  Created by Oh Sangho on 2/24/24.
//  Copyright © 2024 com.shoh.app. All rights reserved.
//

import Foundation

import SearchDomainInterface

final class SearchEventBrokerImpl: SearchEventBroker {
    
    weak var userSearchDelegate: (any SearchEventBrokerDelegate)?
    weak var favoriteSearchDelegate: (any SearchEventBrokerDelegate)?
    
    func setUserDelegate(_ delegate: any SearchEventBrokerDelegate) {
        userSearchDelegate = delegate
    }
    
    func setFavoriteDelegate(_ delegate: any SearchEventBrokerDelegate) {
        favoriteSearchDelegate = delegate
    }
    
    func didUpdateFromUserSearch(for userId: Int, isFavorite: Bool) {
        favoriteSearchDelegate?.favoritesDidUpdate(for: userId, isFavorite: isFavorite)
    }
    
    func didUpdateFromFavoriteSearch(for userId: Int, isFavorite: Bool) {
        userSearchDelegate?.favoritesDidUpdate(for: userId, isFavorite: isFavorite)
    }
}
