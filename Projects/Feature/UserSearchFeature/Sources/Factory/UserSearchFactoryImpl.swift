//
//  UserSearchFactoryImpl.swift
//  UserSearchFeature
//
//  Created by Oh Sangho on 2/20/24.
//  Copyright © 2024 com.shoh. All rights reserved.
//

import UIKit

import BaseFeature
import UserSearchFeatureInterface
import SearchDomainInterface

struct UserSearchFactoryImpl: UserSearchFactory {
    
    private let searchUseCase: any SearchUseCase
    private let searchEventBroker: any SearchEventBroker
    
    init(
        searchUseCase: any SearchUseCase,
        searchEventBroker: any SearchEventBroker
    ) {
        self.searchUseCase = searchUseCase
        self.searchEventBroker = searchEventBroker
    }
    
    func makeViewController() -> UIViewController {
        let viewController: UserSearchViewController = .instantiate(bundle: .module)
        viewController.title = "API"
        viewController.reactor = UserSearchViewReactor(
            searchUseCase: searchUseCase,
            searchEventBroker: searchEventBroker
        )
        
        return viewController
    }
}
