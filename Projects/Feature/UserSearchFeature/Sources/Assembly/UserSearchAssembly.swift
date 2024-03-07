//
//  UserSearchAssembly.swift
//  UserSearchFeature
//
//  Created by Oh Sangho on 2/20/24.
//  Copyright © 2024 com.shoh. All rights reserved.
//

import Foundation

import Swinject

import UserSearchFeatureInterface
import SearchDomainInterface
import GlobalThirdPartyLibrary

public final class UserSearchAssembly: Assembly {
    
    public init() {}
    
    public func assemble(container: Container) {
        container.register(UserSearchFactory.self) { r in
            UserSearchFactoryImpl(
                searchUseCase: r.resolve(SearchUseCase.self),
                searchEventBroker: r.resolve(SearchEventBroker.self)
            )
        }
    }
}
