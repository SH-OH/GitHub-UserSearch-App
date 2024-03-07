//
//  PaginationState.swift
//  SearchDomainInterface
//
//  Created by Oh Sangho on 2/21/24.
//  Copyright © 2024 com.shoh. All rights reserved.
//

import Foundation
import UIKit

public struct PaginationState {
    
    /// default: 30, max 100.
    public let perPage: Int
    /// default: 1.
    public let startPage: Int
    
    public var currentPage: Int
    public var isLoading: Bool = false
    
    let thresholdCount: Int = 5
    
    public init(perPage: Int = 30, startPage: Int = 1) {
        self.perPage = perPage
        self.startPage = startPage
        self.currentPage = startPage
    }
    
    public func shouldLoadNextPage(itemCount: Int, at indexPath: IndexPath) -> Bool {
        let threshold = threshold(itemCount: itemCount)
        
        return !isLoading && indexPath.row >= threshold && perPage <= itemCount
    }
    
    public func reset() -> Self {
        var newState = self
        newState.isLoading = true
        newState.currentPage = startPage
        return newState
    }
    
    public func prepareNextPage() -> Self {
        var newState = self
        newState.isLoading = true
        newState.currentPage += 1
        return newState
    }
    
    public func finish() -> Self {
        var newState = self
        newState.isLoading = false
        return newState
    }
}

private extension PaginationState {
    func threshold(itemCount: Int) -> Int {
        max(0, itemCount - thresholdCount)
    }
}
