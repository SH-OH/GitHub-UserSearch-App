//
//  NibLoadableView.swift
//  BaseFeature
//
//  Created by Oh Sangho on 2/21/24.
//  Copyright © 2024 com.shoh.app. All rights reserved.
//

import Foundation
import UIKit

open class NibLoadableView: UIView, NibLoadable {
    
    var fileName: String { String(describing: Self.self) }
    
    /// 해당 클래스를 resource가 있는 static 모듈에서 상속받아서 사용하려는 경우,
    /// 반드시, bundle을 override 해서 리소스 번들을 주입해주세요.
    open var bundle: Bundle { Bundle(for: Self.self) }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        configureView()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        configureView()
    }
    
    open func configureView() {}
}
