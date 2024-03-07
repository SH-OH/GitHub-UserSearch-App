//
//  NetworkError.swift
//  NetworkingInterface
//
//  Created by Oh Sangho on 2/21/24.
//  Copyright © 2024 com.shoh. All rights reserved.
//

import Foundation

import NetworkingInterface

enum NetworkError: Error {
    case invalidURL
    case statusCode(URLResponse)
    case underlying(Error)
}

extension NetworkError {
    var response: URLResponse? {
        switch self {
        case let .statusCode(response):
            return response
        default:
            return nil
        }
    }
}
