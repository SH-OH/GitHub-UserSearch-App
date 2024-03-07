//
//  CircleView.swift
//  DesignSystem
//
//  Created by Oh Sangho on 2/22/24.
//  Copyright © 2024 com.shoh.app. All rights reserved.
//

import UIKit

protocol CircleViewable where Self: UIView {
    func layoutCircle()
}

extension CircleViewable {
    func layoutCircle() {
        layer.cornerRadius = bounds.size.width / 2
        layer.masksToBounds = true
    }
}

open class CircleView: UIView, CircleViewable {
    open override func layoutSubviews() {
        super.layoutSubviews()
        layoutCircle()
    }
}

open class CircleImageView: UIImageView, CircleViewable {
    open override func layoutSubviews() {
        super.layoutSubviews()
        layoutCircle()
    }
}
