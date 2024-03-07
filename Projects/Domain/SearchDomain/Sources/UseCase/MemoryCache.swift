//
//  MemoryCache.swift
//  SearchDomain
//
//  Created by Oh Sangho on 3/7/24.
//  Copyright © 2024 com.shoh.app. All rights reserved.
//

import Foundation

actor MemoryCache {
    private(set) var favoriteState: [Int: Bool] = [:]
    
    func updateFavorites(with state: [Int: Bool]) {
        for (id, isFavorited) in state {
            favoriteState[id] = isFavorited
        }
    }
    
    func update(isFavorite: Bool, forKey key: Int) {
        favoriteState[key] = isFavorite
    }
    
    func isFavorite(userId: Int) -> Bool {
        return favoriteState[userId] ?? false
    }
}
