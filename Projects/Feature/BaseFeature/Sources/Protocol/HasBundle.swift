//
//  HasBundle.swift
//  BaseFeature
//
//  Created by Oh Sangho on 2/21/24.
//  Copyright © 2024 com.shoh.app. All rights reserved.
//

import Foundation

public protocol HasBundle {
    static var module: Bundle { get }
}

extension HasBundle where Self: AnyObject {
    public static var module: Bundle {
        Foundation.Bundle(for: Self.self)
    }
}
