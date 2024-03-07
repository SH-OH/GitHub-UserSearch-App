//
//  Observable+Ext.swift
//  GlobalThirdPartyLibrary
//
//  Created by Oh Sangho on 2/21/24.
//  Copyright © 2024 com.shoh.app. All rights reserved.
//

import RxSwift

public extension Observable {
    func merge(with other: Observable<Element>) -> Observable<Element> {
        Observable.merge(self, other)
    }
}
