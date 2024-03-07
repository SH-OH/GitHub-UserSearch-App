//
//  FavoriteSearchDiffableDataSource.swift
//  FavoriteSearchFeature
//
//  Created by Oh Sangho on 2/25/24.
//  Copyright © 2024 com.shoh.app. All rights reserved.
//

import UIKit

import SearchDomainInterface
import FoundationUtility


final class FavoriteSearchDiffableDataSource: UITableViewDiffableDataSource<FavoriteSearchDiffableDataSource.Section, UserSearchModel> {
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, UserSearchModel>
    
    struct Section: Hashable {
        var title: String
        var items: [UserSearchModel]
    }

    func update(with items: [UserSearchModel]) {
        let grouped = Dictionary(grouping: items) { (user: UserSearchModel) -> String in
            if let firstChar = user.nickname.first?.uppercased() {
                if firstChar.isLatin {
                    return String(firstChar.prefix(1))
                } else if firstChar.isHangul,
                          let consonant = HangulComposer.initialConsonant.extractHangulInitialConsonant(char: firstChar) {
                    return consonant
                }
            }
            
            return ""
        }
        
        let sections = grouped
            .map({ Section(title: $0.key, items: $0.value) })
            .sorted(by: { $0.title < $1.title })
        
        var snapshot = Snapshot()
        snapshot.appendSections(sections)
        sections.forEach { section in
            snapshot.appendItems(section.items, toSection: section)
        }
        
        apply(snapshot, animatingDifferences: true)
    }
}
