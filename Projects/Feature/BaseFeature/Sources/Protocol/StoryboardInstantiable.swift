//
//  StoryboardInstantiable.swift
//  BaseFeature
//
//  Created by Oh Sangho on 2/21/24.
//  Copyright © 2024 com.shoh. All rights reserved.
//

import UIKit

public protocol StoryboardInstantiable: AnyObject {
    static func instantiate<T: UIViewController>(bundle: Bundle) -> T
}

extension StoryboardInstantiable where Self: UIViewController & HasFileName {
    public static func instantiate<T: UIViewController>(bundle: Bundle) -> T {
        let storyboard = UIStoryboard(name: fileName, bundle: bundle)
        
        guard let viewController = storyboard.instantiateInitialViewController() as? T else {
            fatalError("Cannot instantiate initial view controller \(Self.self) from storyboard")
        }
        
        return viewController
    }
}
