//
//  NetworkService.swift
//  NetworkingInterface
//
//  Created by Oh Sangho on 2/21/24.
//  Copyright © 2024 com.shoh. All rights reserved.
//

import Foundation

public protocol NetworkService {
    func request<T: Decodable>(target: TargetType) async throws -> T
}
