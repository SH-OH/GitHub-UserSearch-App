//
//  ObservableConvertibleType+Ext.swift
//  GlobalThirdPartyLibrary
//
//  Created by Oh Sangho on 2/21/24.
//  Copyright © 2024 com.shoh.app. All rights reserved.
//

import RxSwift
import RxCocoa

public extension ObservableConvertibleType {
    
    func asDriverWithEmpty() -> Driver<Element> {
        asDriver(onErrorDriveWith: .empty())
    }
}
