//
//  FavoriteSearchViewController.swift
//  FavoriteSearchFeature
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
import SearchDomainInterface
import DesignSystem
import HomeFeatureInterface

final class FavoriteSearchViewController: BaseViewController,
                                          ReactorViewBindable,
                                          Alertable {
    
    typealias Reactor = FavoriteSearchViewReactor
    
    @IBOutlet private weak var searchTextField: DefaultTextField!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private lazy var refreshControl: UIRefreshControl = .init()
    private lazy var dataSource: FavoriteSearchDiffableDataSource = .init(
        tableView: tableView
    ) { tableView, indexPath, item in
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: FavoriteSearchItemCell.self)
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
        tableView.registerNib(cellType: FavoriteSearchItemCell.self, bundle: .module)
        tableView.registerNib(headerFooterViewType: FavoriteSearchSectionHeaderView.self, bundle: .module)
        tableView.refreshControl = refreshControl
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.delegate = self
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
        .debounce(.milliseconds(400), scheduler: MainScheduler.instance)
        .skip(1)
        .map(Reactor.Action.searchTextFieldDidEdit)
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .map({ Reactor.Action.refresh })
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(_ reactor: Reactor) {
        reactor.state.map(\.keyword)
            .distinctUntilChanged()
            .map({ _ in Reactor.Action.fetchFavoriteUsersFromLocalDB })
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$users)
            .asDriverWithEmpty()
            .drive(with: self, onNext: { owner, users in
                owner.dataSource.update(with: users)
            })
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

extension FavoriteSearchViewController: FavoriteSearchItemCellDelegate {
    func favoriteButtonDidTap(for item: UserSearchModel, isFavorite: Bool) {
        reactor?.action.onNext(.favoriteButtonDidTap(user: item, isFavorite: isFavorite))
    }
}

extension FavoriteSearchViewController: HomeDataUpdateListener {
    func didTabChange() {
        reactor?.action.onNext(.refresh)
    }
}

extension FavoriteSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(FavoriteSearchSectionHeaderView.self)
        let snapshot = dataSource.snapshot()
        headerView?.configure(snapshot.sectionIdentifiers[section].title)
        return headerView
    }
}
