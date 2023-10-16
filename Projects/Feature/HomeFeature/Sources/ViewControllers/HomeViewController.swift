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

final class HomeViewController: UIViewController {
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
    
    private lazy var searchBarTouchView = UIView().then {
        $0.backgroundColor = .none
        $0.addTapGesture(target: self, action: #selector(navigateToSearch))
    }
    private lazy var contentsCollectionView = makeCollectionView(scrollDirection: .vertical).then {
        $0.setRound([.topLeft, .topRight], radius: 12)
        $0.backgroundColor = .setColor(.sub(.white))
        $0.register(ContentsCollectionViewCell.self, forCellWithReuseIdentifier: ContentsCollectionViewCell.identifier)
        $0.register(ContentsHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ContentsHeaderView.identifier)
    }
    
    private let contentsInsets = UIEdgeInsets(top: 16, left: 24, bottom: 20, right: 24)
    private let contentsCellSpacing: CGFloat = 16
    
    private let contentsCount = 4 // 더미
    
    private let headerViewHeight: CGFloat = 280
    
    var viewModel: HomeViewModel!
    
    init(viewModel: HomeViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        makeConstraints()
    }
}

// MARK: - Objc 함수
extension HomeViewController {
    @objc private func navigateToSearch() {
        print("네비게이션하렴")
    }
}

// MARK: - UI 관련 함수
extension HomeViewController {
    private func addSubViews() {
        view.addSubviews(blueBackgroundView, whiteBackgroundView, containerView)
        containerView.addSubviews(logoImage, scrollview)
        scrollview.addSubviews(searchBar, contentsCollectionView)
        searchBar.addSubviews(searchBarTouchView)
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
        
        searchBarTouchView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        contentsCollectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(24)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(calculateHeight(count: contentsCount, dividingBy: 2, cellHeight: 201, lineSpacing: 24, insets: contentsInsets) + headerViewHeight) // 유동적으로
            $0.bottom.equalToSuperview()
        }
    }
}

// MARK: - CollectionView 관련 함수
extension HomeViewController {
    private func makeCollectionView(scrollDirection: UICollectionView.ScrollDirection) -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = scrollDirection
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
            $0.delegate = self
            $0.dataSource = self
            $0.showsHorizontalScrollIndicator = false
            $0.showsVerticalScrollIndicator = false
        }
        return collectionView
    }
    
    private func calculateHeight(count: Int, dividingBy: CGFloat, cellHeight: CGFloat, lineSpacing: CGFloat, insets: UIEdgeInsets) -> CGFloat { // count: List.cound
        let count = CGFloat(count)
        let heightCount = count / dividingBy + count.truncatingRemainder(dividingBy: dividingBy)
        return heightCount * cellHeight + (heightCount - 1) * lineSpacing + insets.top + insets.bottom
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 셀 크기
        return CGSize(width: (APP_WIDTH() - contentsInsets.left - contentsInsets.right - contentsCellSpacing) / 2, height: 201)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // 줄 간격
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        // 옆 간격
        return contentsCellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ContentsHeaderView.identifier, for: indexPath) as! ContentsHeaderView
            return headerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        // 헤더 뷰의 크기 반환
        return CGSize(width: APP_WIDTH(), height: headerViewHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        contentsInsets
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 아이템 개수
        return contentsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { // data bind
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentsCollectionViewCell.identifier, for: indexPath)
                as? ContentsCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }
}
