//
//  ContentsHeaderView.swift
//  MyPageFeature
//
//  Created by 박의서 on 2023/10/14.
//  Copyright © 2023 com. All rights reserved.
//

import UIKit
import UtilityModule
import Then
import SnapKit
import DesignSystem

final class ContentsHeaderView: UICollectionReusableView {
    static let identifier = "ContentsHeaderView"
    
    private let cellSpacing: CGFloat = 30
    private let collectionViewInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
    private lazy var cellSize = CGSize(width: (APP_WIDTH() - 30 - 30 - cellSpacing * 3) / 4, height: 70)
    private let lineSpacing: CGFloat = 32
    
    public lazy var categoryCollectionView = makeCollectionView(scrollDirection: .vertical).then {
        $0.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
    }
    
    private let contentsTitle = AlleyLabel("인쇄가 어려운 당신에게", font: .subtitle1)
    
    private lazy var showMoreTouchView = UIView().then {
        $0.backgroundColor = .none
        $0.addTapGesture(target: self, action: #selector(navigateToAllContents))
    }
    
    private let showMoreContainer = UIView()

    private let showMoreText = AlleyLabel("더보기", font: .caption1)
    
    private let showMoreIcon = UIImageView().then {
        $0.image = DesignSystemAsset.Icon.rightArrow.image
        $0.contentMode = .scaleAspectFill
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .setColor(.sub(.white))
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ContentsHeaderView {
    private func addSubviews() {
        addSubviews(categoryCollectionView, contentsTitle, showMoreContainer)
        showMoreContainer.addSubviews(showMoreText, showMoreIcon)
        showMoreContainer.addSubviews(showMoreTouchView)
    }
    
    private func makeConstraints() {
        categoryCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40)
            $0.leading.trailing.equalToSuperview().inset(24)
//            $0.height.equalTo(cellSize.height * 2 + lineSpacing)
            $0.height.equalTo(172)
        }
        contentsTitle.snp.makeConstraints {
            $0.top.equalTo(categoryCollectionView.snp.bottom).offset(42)
            $0.leading.equalToSuperview().inset(24)
        }
        showMoreContainer.snp.makeConstraints {
            $0.centerY.equalTo(contentsTitle)
            $0.width.equalTo(44)
            $0.trailing.equalToSuperview().inset(24)
        }
        showMoreText.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        showMoreIcon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.equalTo(9)
            $0.leading.equalTo(showMoreText.snp.trailing).offset(3)
        }
        showMoreTouchView.snp.makeConstraints {
            $0.width.height.equalTo(40)
            $0.edges.equalToSuperview()
        }
    }
}

extension ContentsHeaderView {
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
    
    @objc
    private func navigateToAllContents() {
        print("탭탭")
    }
}

extension ContentsHeaderView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 셀 크기
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // 줄 간격
        return lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        // 옆 간격
        return cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        collectionViewInsets
    }
}

extension ContentsHeaderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 아이템 개수
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { // data bind
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath)
                as? CategoryCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }
}
