//
//  Alertable.swift
//  BaseFeature
//
//  Created by Oh Sangho on 2/23/24.
//  Copyright © 2024 com.shoh.app. All rights reserved.
//

import UIKit

public protocol Alertable where Self: UIViewController {
    func showAlert(
        message: String,
        confirmTitle: String
    )
}

extension Alertable {
    public func showAlert(
        message: String,
        confirmTitle: String = "확인"
    ) {
        let controller = UIAlertController(
            title: nil,
            message: message,
            preferredStyle: .alert
        )
        let confirmAction = UIAlertAction(title: confirmTitle, style: .default)
        
        controller.addAction(confirmAction)
        
        self.present(controller, animated: true)
    }
}
