//
//  HomeAssembly.swift
//  HomeFeature
//
//  Created by Oh Sangho on 2/24/24.
//  Copyright © 2024 com.shoh.app. All rights reserved.
//

import Foundation

import Swinject

import HomeFeatureInterface
import UserSearchFeatureInterface
import FavoriteSearchFeatureInterface
import GlobalThirdPartyLibrary

public final class HomeAssembly: Assembly {
    
    public init() {}
    
    public func assemble(container: Container) {
        container.register(HomeFactory.self) { r in
            HomeFactoryImpl(
                userSearchFactory: r.resolve(UserSearchFactory.self),
                favoriteSearchFactory: r.resolve(FavoriteSearchFactory.self)
            )
        }
    }
}
