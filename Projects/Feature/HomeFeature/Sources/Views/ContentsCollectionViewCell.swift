//
//  CategoryCollectionViewCell.swift
//  HomeFeatureInterface
//
//  Created by 박의서 on 2023/10/12.
//  Copyright © 2023 com. All rights reserved.
//

import UIKit
import Then
import SnapKit
import DesignSystem
import Kingfisher
import ContentDomainInterface

final class ContentsCollectionViewCell: UICollectionViewCell {
    static let identifier = "ContentsCollectionViewCell"
    
    private let image = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .red
    }
    
    private let label = AlleyLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .setColor(.sub(.white))
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ContentsCollectionViewCell {
    private func addSubviews() {
        contentView.addSubviews(image, label)
    }
    
    private func makeConstraints() {
        image.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.width.height.equalTo(163)
            $0.centerX.equalToSuperview()
        }
        
        label.snp.makeConstraints {
            $0.top.equalTo(image.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
    }
    
    public func update(model: ContentEntity) {
        image.kf.setImage(with: URL(string: model.thumbnail))
        label.setTitle(title: model.title, textColor: .sub(.black), font: .caption1)
    }
}
