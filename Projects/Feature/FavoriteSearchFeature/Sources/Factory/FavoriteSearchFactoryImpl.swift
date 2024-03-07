//
//  FavoriteSearchFactoryImpl.swift
//  FavoriteSearchFeature
//
//  Created by Oh Sangho on 2/23/24.
//  Copyright © 2024 com.shoh.app. All rights reserved.
//

import UIKit

import BaseFeature
import FavoriteSearchFeatureInterface
import SearchDomainInterface

struct FavoriteSearchFactoryImpl: FavoriteSearchFactory {
    
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
        let viewController: FavoriteSearchViewController = .instantiate(bundle: .module)
        viewController.title = "로컬"
        viewController.reactor = FavoriteSearchViewReactor(
            searchUseCase: searchUseCase,
            searchEventBroker: searchEventBroker
        )
        
        return viewController
    }
}
