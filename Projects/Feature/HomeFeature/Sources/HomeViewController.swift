//
//  HomeViewController.swift
//  HomeFeatureInterface
//
//  Created by Oh Sangho on 2/23/24.
//  Copyright © 2024 com.shoh.app. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import ReactorKit

import BaseFeature
import UIKitUtility
import GlobalThirdPartyLibrary
import FoundationUtility
import DesignSystem
import HomeFeatureInterface

final class HomeViewController: BaseViewController,
                                ReactorViewBindable {
	
	typealias Reactor = HomeViewReactor
    
    var pageViewControllers: [any HomeDataUpdateListener] = []
    
    @IBOutlet private weak var topTabView: CustomTopTabView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var pageStackView: UIStackView!
    
    private var currentPage: Int = 0
    
	@available(*, unavailable, message: "use instantiate")
	init() {
		super.init(nibName: nil, bundle: nil)
	}
	
	@available(*, unavailable, message: "use instantiate")
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	@available(*, unavailable, message: "use instantiate")
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
    override func configureView() {
        configureTopTabView(with: pageViewControllers)
        configurePageStackView(with: pageViewControllers)
    }
    
    func bindAction(_ reactor: HomeViewReactor) {
        
    }
    
    func bindState(_ reactor: HomeViewReactor) {
        
    }
}

extension HomeViewController: CustomTopTabViewDelegate {
    func tabChanged(index: Int) {
        let pageOffset = CGFloat(index) * scrollView.frame.width
        scrollView.setContentOffset(CGPoint(x: pageOffset, y: 0), animated: true)
        
        view.endEditing(true)
        pageViewControllers[safe: index]?.didTabChange()
        
        currentPage = index
    }
}

private extension HomeViewController {
    func configureTopTabView(with viewControllers: [UIViewController]) {
        let tabLabels: [UIView] = viewControllers
            .compactMap({
                guard let title = $0.title else { return nil }
                
                let label = UILabel()
                label.text = title
                label.font = .systemFont(ofSize: 20, weight: .medium)
                label.textColor = .black
                label.textAlignment = .center
                
                return label
            })
        
        topTabView.setupTabs(views: tabLabels)
        topTabView.delegate = self
    }
    
    func configurePageStackView(with viewControllers: [UIViewController]) {
        viewControllers
            .forEach { viewController in
                addChild(viewController)
                view.addSubview(viewController.view)
                viewController.didMove(toParent: self)
                pageStackView.addArrangedSubview(viewController.view)
                
                viewController.view.translatesAutoresizingMaskIntoConstraints = false
                viewController.view.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
            }
    }
}
