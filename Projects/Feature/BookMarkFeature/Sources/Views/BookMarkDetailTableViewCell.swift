//
//  BookMarkTableViewCell.swift
//  BookMarkModuleDemo
//
//  Created by yongbeomkwak on 10/14/23.
//  Copyright © 2023 com. All rights reserved.
//

import UIKit
import DesignSystem
import UtilityModule
import BookMarkDomainInterface


public protocol BookMarkDetailTableViewCellDelegate: AnyObject {
    func tapBookMark(id: Int?)
}


class BookMarkDetailTableViewCell: UITableViewCell {

    static let identifier: String = "BookMarkDetailTableViewCell"
    
    lazy var containerView: UIView = UIView()
    lazy var titleLabel: AlleyLabel = AlleyLabel().then{
        $0.numberOfLines = 1

    }
    lazy var subtitleLabel: AlleyLabel = AlleyLabel().then {

        $0.numberOfLines = 1
    
    }
    lazy var tagLabel: AlleyLabel = AlleyLabel().then {
        $0.numberOfLines = 1

    }
    lazy var button: UIButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Icon.blueBookMark.image, for: .normal)
    }
    
    lazy var baseLine: UIView = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.1)
    }
    
    public weak var deleagte: BookMarkDetailTableViewCellDelegate?
    var model: BookMarkEntity!
    var index: Int!
    var isEdit: Bool!
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            addSubviews()
            makeConstraints()
            button.addTarget(self, action: #selector(tapCheck), for: .touchUpInside)
        
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}

extension BookMarkDetailTableViewCell {
    func addSubviews() {
        self.contentView.addSubviews(containerView,baseLine,button)
        self.containerView.addSubviews(titleLabel,subtitleLabel,tagLabel)
        
    }
    
    func makeConstraints() {
        
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(13)
            $0.left.equalToSuperview().inset(24)
            $0.right.equalTo(button.snp.left).offset(-5)
        }
        
        titleLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(tagLabel.snp.bottom)
            
        }
        
        
        tagLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalTo(titleLabel.snp.left)
            $0.right.equalToSuperview()
            
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.left.equalTo(titleLabel.snp.left)
            $0.right.equalTo(tagLabel.snp.right)
            $0.bottom.equalToSuperview()
        }
        
        button.snp.makeConstraints {
            $0.width.height.equalTo(32)
            $0.centerY.equalTo(containerView.snp.centerY)
            $0.right.equalToSuperview().inset(24)
        }
        
        baseLine.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.equalToSuperview().inset(24)
            $0.right.equalToSuperview().inset(26)
            $0.top.equalTo(containerView.snp.bottom).offset(20)
            $0.bottom.equalToSuperview()
        }
        
        
    }
    
    public func update(model: BookMarkEntity, isLast: Bool) {
        self.model = model

        titleLabel.setTitle(title: model.product.name, textColor: .sub(.black), font: .subtitle1)
        
        
        titleLabel.lineBreakMode = .byTruncatingTail
        subtitleLabel.lineBreakMode = .byTruncatingTail
        tagLabel.lineBreakMode = .byTruncatingTail
        baseLine.layer.opacity = isLast ? 0 : 1
    }
    
    @objc func tapCheck() {
        
        deleagte?.tapBookMark(id: model.id)
    }
}
