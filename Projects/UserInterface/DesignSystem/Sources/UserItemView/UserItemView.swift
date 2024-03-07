//
//  UserItemView.swift
//  DesignSystem
//
//  Created by Oh Sangho on 2/23/24.
//  Copyright © 2024 com.shoh.app. All rights reserved.
//

import UIKit

import Kingfisher

public struct UserItemViewModel: Equatable {
    let nickname: String
    let profileUrl: URL?
    let isFavorited: Bool
    
    public init(nickname: String, profileUrl: URL?, isFavorited: Bool) {
        self.nickname = nickname
        self.profileUrl = profileUrl
        self.isFavorited = isFavorited
    }
}

public protocol UserItemViewDelegate: AnyObject {
    func favoriteButtonDidTap(isFavorite: Bool)
}

public final class UserItemView: NibLoadableView {
    
    public weak var delegate: (any UserItemViewDelegate)?
    
    @IBOutlet private weak var profileImageView: CircleImageView!
    @IBOutlet private weak var nicknameLabel: UILabel!
    @IBOutlet private weak var favoriteButton: UIButton!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }
    
    public override func configureView() {
        profileImageView.layer.borderColor = UIColor.darkGray.cgColor
        profileImageView.layer.borderWidth = 1
    }
    
    public func updateContent(with viewModel: UserItemViewModel) {
        profileImageView.kf.setImage(with: viewModel.profileUrl)
        nicknameLabel.text = viewModel.nickname
        favoriteButton.isSelected = viewModel.isFavorited
    }
    
    @IBAction private func favoriteButtonAction(_ sender: UIButton) {
        delegate?.favoriteButtonDidTap(isFavorite: !favoriteButton.isSelected)
    }
}
