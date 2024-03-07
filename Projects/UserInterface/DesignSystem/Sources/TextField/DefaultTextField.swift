//
//  DefaultTextField.swift
//  DesignSystem
//
//  Created by Oh Sangho on 2/21/24.
//  Copyright © 2024 com.shoh.app. All rights reserved.
//

import UIKit

open class DefaultTextField: UITextField {
    
    open override var placeholder: String? {
        didSet { setNeedsLayout() }
    }
    
    public var textAreaInsets: UIEdgeInsets = .init(
        top: 0,
        left: 12,
        bottom: 0,
        right: 12
    )
    
    public init(placeholder: String? = "") {
        super.init(frame: .zero)
        self.placeholder = placeholder
        configure()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        setPlaceholderTextColor()
    }
    
    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textAreaInsets)
    }

    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textAreaInsets)
    }
    
    open override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.clearButtonRect(forBounds: bounds)
        return rect.offsetBy(
            dx: -6,
            dy: 0
        )
    }
}

private extension DefaultTextField {
    func configure() {
        backgroundColor = .white
        textColor = .black
        font = .systemFont(ofSize: 18)
        clearButtonMode = .whileEditing
        returnKeyType = .search
        
        borderStyle = .none
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
    }
    
    func setPlaceholderTextColor() {
        guard let placeholder else { return }
        
        attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: UIColor.darkGray
            ]
        )
    }
}
