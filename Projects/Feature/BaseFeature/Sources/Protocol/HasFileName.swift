//
//  HasFileName.swift
//  BaseFeature
//
//  Created by Oh Sangho on 2/21/24.
//  Copyright © 2024 com.shoh.app. All rights reserved.
//

import Foundation

public protocol HasFileName {
    static var fileName: String { get }
}

extension HasFileName {
    public static var fileName: String {
        return String(describing: Self.self)
    }
}
