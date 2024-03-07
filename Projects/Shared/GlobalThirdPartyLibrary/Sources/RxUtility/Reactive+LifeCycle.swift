//
//  Reactive+LifeCycle.swift
//  GlobalThirdPartyLibrary
//
//  Created by Oh Sangho on 2/24/24.
//  Copyright © 2024 com.shoh.app. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public extension Reactive where Base: UIViewController {
    var viewWillAppear: ControlEvent<Void> {
        let source = methodInvoked(#selector(Base.viewWillAppear)).mapToVoid()
        return ControlEvent(events: source)
    }
}
