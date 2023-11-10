//
//  MainTabBarController.swift
//  MainTabFeatureInterface
//
//  Created by 박의서 on 2023/10/05.
//  Copyright © 2023 com. All rights reserved.
//

import UIKit
import DesignSystem
import MyPageFeatureInterface
import HomeFeatureInterface
import NearByMeFeatureInterface
import UtilityModule

public class MainTabBarController: UITabBarController {
    private var myPageFactory: any MyPageFactory
    private var homeFactory: any HomeFactory
    private var nearByMeFactory: any NearByMeFactory
    // 탭바 이미지 적용 필요

    private lazy var tabbarControllers: [UIViewController] = {
        let viewControllers = [
            homeFactory.makeView().wrapNavigationController,
            nearByMeFactory.makeView().wrapNavigationController,
            myPageFactory.makeView().wrapNavigationController
        ]
        return viewControllers
    }()
    
    private let tabBarItems: [UITabBarItem] = {
        let items = [
            UITabBarItem(title: "홈", image: DesignSystemAsset.BottomTabIcon.defaultHome.image, selectedImage: DesignSystemAsset.BottomTabIcon.selectedHome.image),
            UITabBarItem(title: "인쇄소 찾기", image: DesignSystemAsset.BottomTabIcon.defaultSearch.image, selectedImage: DesignSystemAsset.BottomTabIcon.selectedSearch.image),
        UITabBarItem(title: "나의 골목", image: DesignSystemAsset.BottomTabIcon.defaultPerson.image, selectedImage: DesignSystemAsset.BottomTabIcon.selectedPerson.image)
        ]
        
        return items
    }()

    init(myPageFactory: MyPageFactory, homeFactory: HomeFactory, nearByMeFactory: NearByMeFactory) {
        self.myPageFactory = myPageFactory
        self.homeFactory = homeFactory
        self.nearByMeFactory = nearByMeFactory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.backgroundColor = .brown
        configureUI()
        styleTabBar()
        
    }
}

extension MainTabBarController {
    private func configureUI() {
        for (index, item) in tabBarItems.enumerated() {
            tabbarControllers[index].tabBarItem = item
        }
        setViewControllers(tabbarControllers, animated: true)
    }
    
    private func styleTabBar() {
        let normalAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.setFont(.body3),
            NSAttributedString.Key.foregroundColor: UIColor.setColor(.grey(.grey600))
        ]
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.setColor(.grey(.grey1000))
        ]
        self.tabBar.backgroundColor = .setColor(.sub(.white))
        self.tabBar.layer.borderColor = UIColor.setColor(.grey(.grey100)).cgColor
        self.tabBar.layer.borderWidth = 1.0
        for item in tabBarItems {
            item.setTitleTextAttributes(normalAttributes, for: .normal)
            item.setTitleTextAttributes(selectedAttributes, for: .selected)
            item.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
            item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 2)
        }
        
        self.tabBar.tintColor =  DesignSystemAsset.Grey.grey1000.color  // 선택된 탭바 아이템 색 변경
    }
}
