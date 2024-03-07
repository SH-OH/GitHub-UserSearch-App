//
//  SimpleTableViewDiffableDataSource.swift
//  UIKitUtility
//
//  Created by Oh Sangho on 2/23/24.
//  Copyright © 2024 com.shoh.app. All rights reserved.
//

import UIKit

open class SimpleTableViewDiffableDataSource<Item: Hashable>:
    UITableViewDiffableDataSource<SimpleTableViewDiffableDataSource.Section, Item> {
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    public enum Section {
        case main
    }
    
    public func update(with items: [Item]) {
        var snapshot = Snapshot()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        apply(snapshot, animatingDifferences: true)
    }
}
