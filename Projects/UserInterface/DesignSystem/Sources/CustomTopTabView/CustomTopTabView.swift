//
//  CustomTopTabView.swift
//  DesignSystem
//
//  Created by Oh Sangho on 2/24/24.
//  Copyright © 2024 com.shoh.app. All rights reserved.
//

import UIKit

public protocol CustomTopTabViewDelegate: AnyObject {
    func tabChanged(index: Int)
}

open class CustomTopTabView: NibLoadableView {
    
    public weak var delegate: (any CustomTopTabViewDelegate)?
    
    @IBOutlet private weak var tabStackView: UIStackView!
    @IBOutlet private weak var indicatorBar: UIView!
    @IBOutlet private var indicatorBarLeadingConstraint: NSLayoutConstraint!
    
    private var indicatorBarWidthConstraint: NSLayoutConstraint!
    
    private var tabCount: Int { tabStackView.arrangedSubviews.count }
    
    public func setupTabs(views: [UIView]) {
        views.enumerated()
            .forEach({
                setupTab(view: $0.element, isFirst: $0.offset == 0)
            })
        
        indicatorBar.widthAnchor.constraint(
            equalTo: tabStackView.widthAnchor,
            multiplier: 1 / CGFloat(tabCount)
        ).isActive = true
    }
    
    public func setIndex(index: Int) {
        tabDidChange(index: index)
    }
}

private extension CustomTopTabView {
    func tabDidChange(index: Int) {
        indicatorBarLeadingConstraint.constant = (tabStackView.frame.width / CGFloat(tabCount)) * CGFloat(index)
        
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }
    
    @objc func tabViewDidTap(_ tapGesture: UITapGestureRecognizer) {
        guard let view = tapGesture.view else { return }
        
        tabDidChange(index: view.tag)
        
        delegate?.tabChanged(index: view.tag)
    }
    
    func setupTab(view: UIView, isFirst: Bool) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tabViewDidTap))
        view.isUserInteractionEnabled = true
        tabStackView.addArrangedSubview(view)
        view.tag = index(of: view)
        view.addGestureRecognizer(tapGesture)
    }
    
    func index(of view: UIView) -> Int {
        tabStackView.arrangedSubviews.firstIndex(of: view) ?? 0
    }
}
