//
//  NibLoadable.swift
//  BaseFeature
//
//  Created by Oh Sangho on 2/21/24.
//  Copyright © 2024 com.shoh.app. All rights reserved.
//

import Foundation
import UIKit

public protocol NibLoadable {
    func commonInit()
}

extension NibLoadable where Self: NibLoadableView {
    public func commonInit() {
        let fileName = fileName
        guard let view = bundle.loadNibNamed(
            fileName,
            owner: self,
            options: nil
        )?.first as? UIView else {
            let logInfo = "bundle: \(bundle)" + ", fileName: \(fileName)" + ", owner: \(self)"
            print("Failed load nib " + logInfo)
            return
        }
        
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.topAnchor),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
