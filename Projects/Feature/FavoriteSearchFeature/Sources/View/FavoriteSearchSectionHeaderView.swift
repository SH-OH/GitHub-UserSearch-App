//
//  FavoriteSearchSectionHeaderView.swift
//  FavoriteSearchFeature
//
//  Created by Oh Sangho on 2/25/24.
//  Copyright © 2024 com.shoh.app. All rights reserved.
//

import UIKit

final class FavoriteSearchSectionHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    func configure(_ title: String) {
        titleLabel.text = title
    }
}
