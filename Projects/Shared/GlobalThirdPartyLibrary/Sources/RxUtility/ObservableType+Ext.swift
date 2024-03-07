//
//  ObservableType+Ext.swift
//  GlobalThirdPartyLibrary
//
//  Created by Oh Sangho on 2/21/24.
//  Copyright © 2024 com.shoh.app. All rights reserved.
//

import RxSwift

public extension ObservableType {
    
    func mapToVoid() -> Observable<Void> {
        map({ _ in () })
    }
}
