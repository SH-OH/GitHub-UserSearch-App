//
//  UITableView+Reusable.swift
//  UIKitUtility
//
//  Created by Oh Sangho on 2/21/24.
//  Copyright © 2024 com.shoh. All rights reserved.
//

import UIKit

public extension UITableView {
    
    func register(cellType: (some UITableViewCell).Type) {
        register(
            cellType.self,
            forCellReuseIdentifier: cellType.reuseIdentifier
        )
    }
    
    func registerNib(cellType: (some UITableViewCell).Type, bundle: Bundle) {
        register(
            UINib(nibName: String(describing: cellType.self), bundle: bundle),
            forCellReuseIdentifier: cellType.reuseIdentifier
        )
    }
    
    func register(headerFooterViewType: (some UITableViewHeaderFooterView).Type) {
        register(
            headerFooterViewType.self,
            forHeaderFooterViewReuseIdentifier: headerFooterViewType.reuseIdentifier
        )
    }
    
    func registerNib(headerFooterViewType: (some UITableViewHeaderFooterView).Type, bundle: Bundle) {
        register(
            UINib(nibName: String(describing: headerFooterViewType.self), bundle: bundle),
            forHeaderFooterViewReuseIdentifier: headerFooterViewType.reuseIdentifier
        )
    }
    
    func dequeueReusableCell<T: UITableViewCell>(
        for indexPath: IndexPath,
        cellType: T.Type = T.self
    ) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError(
                "Failed to dequeue a cell with identifier \(cellType.reuseIdentifier) "
                + "matching type \(cellType.self)."
            )
        }
        return cell
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(
        _ viewType: T.Type = T.self
    ) -> T? {
        guard let view = self.dequeueReusableHeaderFooterView(withIdentifier: viewType.reuseIdentifier) as? T? else {
            fatalError(
                "Failed to dequeue a header/footer with identifier \(viewType.reuseIdentifier) "
                + "matching type \(viewType.self)."
            )
        }
        return view
    }
}
