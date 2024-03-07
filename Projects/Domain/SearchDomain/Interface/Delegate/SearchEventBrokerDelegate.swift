//
//  SearchEventBrokerDelegate.swift
//  SearchDomainInterface
//
//  Created by Oh Sangho on 2/24/24.
//  Copyright © 2024 com.shoh.app. All rights reserved.
//

import Foundation

public protocol SearchEventBrokerDelegate: AnyObject {
    func favoritesDidUpdate(for userId: Int, isFavorite: Bool)
}
