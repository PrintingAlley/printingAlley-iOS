//
//  HomeViewController.swift
//  HomeFeatureInterface
//
//  Created by 박의서 on 2023/10/11.
//  Copyright © 2023 com. All rights reserved.
//

import UIKit
import UtilityModule
import DesignSystem
import Then
import SnapKit
import SearchFeatueInterface
import RxSwift
import RxDataSources
import BaseFeature
import CategorySearchFeatureInterface
import BaseFeatureInterface

final class HomeViewController: UIViewController {
    private var searchFactory: any SearchFactory
    public var categorySearchFactory: any CategorySearchFactory
    public var webviewFactory: any WebViewFactory
    
    public var viewModel: HomeViewModel!
    
    let disposeBag = DisposeBag()
    var output: HomeViewModel.Output!
    
    private let blueBackgroundView = UIView().then {
        $0.backgroundColor = .setColor(.mainBlue(.blue500))
    }
    
    private let whiteBackgroundView = UIView().then {
        $0.backgroundColor = .setColor(.sub(.white))
    }
    
    private let logoImage = UIImageView().then {
        $0.image = DesignSystemAsset.Logo.homeLogo.image
        $0.contentMode = .scaleAspectFit
    }
    
    private let containerView = UIView().then {
        $0.backgroundColor = .none
    }
    
    private let scrollview = UIScrollView().then {
        $0.setRound([.topLeft, .topRight], radius: 12)
        $0.backgroundColor = .none
    }
    
    private let searchBar = SearchBar()
    
    private lazy var searchBarButton = UIButton().then {
        $0.addTarget(self, action: #selector(navigateToSearch), for: .touchDown)
        $0.backgroundColor = .none
    }

    public lazy var contentsCollectionView = makeCollectionView(layout: UICollectionViewFlowLayout(), scrollDirection: .vertical, delegate: self, dataSource: self).then {
        $0.setRound([.topLeft, .topRight], radius: 12)
        $0.backgroundColor = .setColor(.sub(.white))
        $0.register(ContentsCollectionViewCell.self, forCellWithReuseIdentifier: ContentsCollectionViewCell.identifier)
        $0.register(ContentsHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ContentsHeaderView.identifier)
    }
    
    public let contentsInsets = UIEdgeInsets(top: 16, left: 24, bottom: 20, right: 24)
    public let contentsCellSpacing: CGFloat = 16
    
    public let contentsCount = 4 // 더미
    
    public let headerViewHeight: CGFloat = 280
    
    init(viewModel: HomeViewModel, searchFactory: SearchFactory, categorySearchFactory: CategorySearchFactory, webviewFacotry: WebViewFactory) {
        self.searchFactory = searchFactory
        self.categorySearchFactory = categorySearchFactory
        self.webviewFactory = webviewFacotry
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        addSubViews()
        makeConstraints()
        bindViewModel()
    }
}

extension HomeViewController {
    func bindViewModel() {
        let input = HomeViewModel.Input()
        
        output = viewModel.transform(input: input)
        
        bindDataSource(output: output)
        
    }

}

// MARK: - Objc 함수
extension HomeViewController {
    @objc private func navigateToSearch() {
        let vc = searchFactory.makeView()
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UI 관련 함수
extension HomeViewController {
    private func addSubViews() {
        view.addSubviews(blueBackgroundView, whiteBackgroundView, containerView)
        containerView.addSubviews(logoImage, scrollview)
        scrollview.addSubviews(searchBar, contentsCollectionView)
        searchBar.addSubviews(searchBarButton)
    }
    
    private func makeConstraints() {
        blueBackgroundView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(APP_HEIGHT() / 5 * 3)
        }

        whiteBackgroundView.snp.makeConstraints {
            $0.top.equalTo(blueBackgroundView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        logoImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(75)
            $0.centerX.equalToSuperview()
        }
        
        scrollview.snp.makeConstraints {
            $0.top.equalTo(logoImage.snp.bottom).offset(24)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        searchBar.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(24)
            $0.height.equalTo(56)
        }
        
        searchBarButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        contentsCollectionView.snp.makeConstraints { // TODO: 웨스트 , contentsCount 말고 데이터 결과 카운트로 어떻게 ??
            $0.top.equalTo(searchBar.snp.bottom).offset(24)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(calculateHeight(count: contentsCount, dividingBy: 2, cellHeight: 201, lineSpacing: 24, insets: contentsInsets) + headerViewHeight) // 유동적으로
            $0.bottom.equalToSuperview()
        }
    }
}

// MARK: - CollectionView 관련 함수
extension HomeViewController {
    private func calculateHeight(count: Int, dividingBy: CGFloat, cellHeight: CGFloat, lineSpacing: CGFloat, insets: UIEdgeInsets) -> CGFloat { // count: List.cound
        let count = CGFloat(count)
        let heightCount = count / dividingBy + count.truncatingRemainder(dividingBy: dividingBy)
        return heightCount * cellHeight + (heightCount - 1) * lineSpacing + insets.top + insets.bottom
    }
}



