//
//  ReactorViewBindable.swift
//  BaseFeature
//
//  Created by Oh Sangho on 2/22/24.
//  Copyright © 2024 com.shoh.app. All rights reserved.
//

import ReactorKit

public protocol ReactorViewBindable: StoryboardView {
    func bindAction(_ reactor: Reactor)
    func bindState(_ reactor: Reactor)
}

public extension ReactorViewBindable {
    func bind(reactor: Reactor) {
        bindAction(reactor)
        bindState(reactor)
    }
}
