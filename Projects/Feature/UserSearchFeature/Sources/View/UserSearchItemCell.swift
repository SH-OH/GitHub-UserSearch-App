//
//  UserSearchItemCell.swift
//  UserSearchFeature
//
//  Created by Oh Sangho on 2/21/24.
//  Copyright © 2024 com.shoh. All rights reserved.
//

import UIKit

import SearchDomainInterface
import DesignSystem

protocol UserSearchItemCellDelegate: AnyObject {
    func favoriteButtonDidTap(for item: UserSearchModel, isFavorite: Bool)
}

final class UserSearchItemCell: UITableViewCell {
    
    weak var delegate: (any UserSearchItemCellDelegate)?
    
    @IBOutlet private weak var itemView: UserItemView!
    
    private var model: UserSearchModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        itemView.delegate = self
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        model = nil
    }
    
    func configure(_ model: UserSearchModel) {
        self.model = model
        itemView.updateContent(
            with: .init(
                nickname: model.nickname,
                profileUrl: model.profileUrl,
                isFavorited: model.isFavorited
            )
        )
    }
}

extension UserSearchItemCell: UserItemViewDelegate {
    func favoriteButtonDidTap(isFavorite: Bool) {
        guard let model else { return }
        
        self.delegate?.favoriteButtonDidTap(for: model, isFavorite: isFavorite)
    }
}
