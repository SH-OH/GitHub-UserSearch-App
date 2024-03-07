//
//  HTTPMethod.swift
//  NetworkingInterface
//
//  Created by Oh Sangho on 2/21/24.
//  Copyright © 2024 com.shoh. All rights reserved.
//

import Foundation

public enum HTTPMethod: String, RawRepresentable {
    case get
    
    public var rawValue: String {
        "\(self)".uppercased()
    }
}
