//
//  UserSearchViewController.swift
//  UserSearchFeature
//
//  Created by Oh Sangho on 2/20/24.
//  Copyright © 2024 com.shoh. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import ReactorKit
import Kingfisher

import BaseFeature
import UIKitUtility
import GlobalThirdPartyLibrary
import SearchDomainInterface
import DesignSystem
import HomeFeatureInterface

final class UserSearchViewController: BaseViewController,
                                      ReactorViewBindable,
                                      Alertable {
    
    typealias Reactor = UserSearchViewReactor
    
    @IBOutlet private weak var searchTextField: DefaultTextField!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private lazy var refreshControl: UIRefreshControl = .init()
    private lazy var dataSource: SimpleTableViewDiffableDataSource<UserSearchModel> = .init(
        tableView: tableView
    ) { tableView, indexPath, item in
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: UserSearchItemCell.self)
        cell.configure(item)
        cell.delegate = self
        
        return cell
    }
    
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
        tableView.refreshControl = refreshControl
        tableView.registerNib(cellType: UserSearchItemCell.self, bundle: .module)
        dataSource.defaultRowAnimation = .fade
    }
    
    func bindAction(_ reactor: Reactor) {
        Observable.just(())
            .map({ Reactor.Action.viewDidLoad })
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        Observable.merge(
            searchTextField.rx.text.orEmpty.asObservable(),
            searchTextField.rx.controlEvent(.editingDidEndOnExit)
                .withLatestFrom(searchTextField.rx.text.orEmpty)
        )
        .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
        .map(Reactor.Action.searchTextFieldDidEdit)
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .map({ Reactor.Action.refresh })
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tableView.rx.willDisplayCell
            .map(\.indexPath)
            .map(Reactor.Action.willDisplayCell)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tableView.rx.prefetchRows
            .map(Reactor.Action.prefetchRows)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tableView.rx.cancelPrefetchingForRows
            .map(Reactor.Action.cancelPrefetchingForRows)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(_ reactor: Reactor) {
        reactor.state.map(\.keyword)
            .distinctUntilChanged()
            .map({ _ in Reactor.Action.fetchUsersFromRemote })
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map(\.users)
            .distinctUntilChanged()
            .asDriverWithEmpty()
            .drive(with: self, onNext: { owner, users in
                owner.dataSource.update(with: users)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map(\.prefetchedImageUrls)
            .map(Array.init)
            .bind(onNext: { ImagePrefetcher(urls: $0).start() })
            .disposed(by: disposeBag)
        
        reactor.state.map(\.canceledPrefetchImageUrls)
            .map(Array.init)
            .bind(onNext: { ImagePrefetcher(urls: $0).stop() })
            .disposed(by: disposeBag)
        
        reactor.state.map(\.isLoadingMap)
            .map({ $0[.refresh] ?? false })
            .distinctUntilChanged()
            .asDriverWithEmpty()
            .drive(with: refreshControl, onNext: { refreshControl, isRefreshing in
                isRefreshing
                ? refreshControl.beginRefreshing()
                : refreshControl.endRefreshing()
                refreshControl.isHidden = !isRefreshing
            })
            .disposed(by: disposeBag)
        
        reactor.state.map(\.isLoadingMap)
            .map({ $0[.default] ?? false })
            .distinctUntilChanged()
            .asDriverWithEmpty()
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$errorMessage)
            .compactMap({ $0 })
            .asDriverWithEmpty()
            .drive(with: self, onNext: { owner, message in
                owner.showAlert(message: message)
            })
            .disposed(by: disposeBag)
    }
}

extension UserSearchViewController: UserSearchItemCellDelegate {
    func favoriteButtonDidTap(for item: UserSearchModel, isFavorite: Bool) {
        reactor?.action.onNext(.favoriteButtonDidTap(user: item, isFavorite: isFavorite))
    }
}

extension UserSearchViewController: HomeDataUpdateListener {
    func didTabChange() {
        reactor?.action.onNext(.didTabChange)
    }
}
