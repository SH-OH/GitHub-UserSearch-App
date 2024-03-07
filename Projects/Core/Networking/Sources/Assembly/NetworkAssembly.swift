//
//  NetworkAssembly.swift
//  NetworkingInterface
//
//  Created by Oh Sangho on 2/21/24.
//  Copyright © 2024 com.shoh. All rights reserved.
//

import Swinject

import NetworkingInterface

public final class NetworkAssembly: Assembly {
    public init() {}
    
    public func assemble(container: Container) {
        container.register(NetworkService.self) { _ in
            return NetworkServiceImpl()
        }
    }
}
