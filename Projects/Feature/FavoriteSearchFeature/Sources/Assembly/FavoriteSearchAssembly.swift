//
//  FavoriteSearchAssembly.swift
//  FavoriteSearchFeature
//
//  Created by Oh Sangho on 2/23/24.
//  Copyright © 2024 com.shoh.app. All rights reserved.
//

import Foundation

import Swinject

import FavoriteSearchFeatureInterface
import SearchDomainInterface
import GlobalThirdPartyLibrary

public final class FavoriteSearchAssembly: Assembly {
    
    public init() {}
    
    public func assemble(container: Container) {
        container.register(FavoriteSearchFactory.self) { r in
            FavoriteSearchFactoryImpl(
                searchUseCase: r.resolve(SearchUseCase.self),
                searchEventBroker: r.resolve(SearchEventBroker.self)
            )
        }
    }
}
