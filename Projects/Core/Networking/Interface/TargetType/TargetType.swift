//
//  TargetType.swift
//  NetworkingInterface
//
//  Created by Oh Sangho on 2/21/24.
//  Copyright © 2024 com.shoh. All rights reserved.
//

import Foundation

public typealias Parameters = [String: Any]
public typealias Headers = [String: String]

public protocol TargetType {
    var baseURL: URL? { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var headers: Headers? { get }
    var errorMap: [Int: Error] { get }
}

public extension TargetType {
    var baseURL: URL? {
        return URL(string: "https://api.github.com")
    }
    var errorMap: [Int: Error] { [:] }
}
