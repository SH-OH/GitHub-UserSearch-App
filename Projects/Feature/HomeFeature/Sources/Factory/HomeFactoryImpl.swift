//
//  HomeFactoryImpl.swift
//  HomeFeatureInterface
//
//  Created by Oh Sangho on 2/23/24.
//  Copyright © 2024 com.shoh.app. All rights reserved.
//

import UIKit

import BaseFeature
import HomeFeatureInterface
import SearchDomainInterface
import UserSearchFeatureInterface
import FavoriteSearchFeatureInterface

struct HomeFactoryImpl: HomeFactory {
    
    private let userSearchFactory: any UserSearchFactory
    private let favoriteSearchFactory: any FavoriteSearchFactory
    
    init(
        userSearchFactory: any UserSearchFactory,
        favoriteSearchFactory: any FavoriteSearchFactory
    ) {
        self.userSearchFactory = userSearchFactory
        self.favoriteSearchFactory = favoriteSearchFactory
    }
    
    func makeViewController() -> UIViewController {
        let viewController: HomeViewController = .instantiate(bundle: .module)
        viewController.pageViewControllers = [
            userSearchFactory.makeViewController(),
            favoriteSearchFactory.makeViewController()
        ].compactMap({ $0 as? HomeDataUpdateListener })
        viewController.reactor = HomeViewReactor()
        
        return viewController
    }
}
