//
//  BaseViewController.swift
//  BaseFeature
//
//  Created by Oh Sangho on 2/21/24.
//  Copyright © 2024 com.shoh. All rights reserved.
//

import UIKit

import RxSwift

open class BaseViewController: UIViewController,
                               HasFileName,
                               StoryboardInstantiable {
    
    public var disposeBag: DisposeBag = .init()
    
    public var fileName: String { Self.fileName }
    
    open override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    open func configureView() {}
}
