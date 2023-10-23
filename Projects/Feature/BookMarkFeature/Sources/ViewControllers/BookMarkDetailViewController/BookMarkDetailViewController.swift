//
//  BookMarkViewController.swift
//  BookMarkModuleDemo
//
//  Created by yongbeomkwak on 10/14/23.
//  Copyright © 2023 com. All rights reserved.
//

import UIKit
import SnapKit
import Then
import DesignSystem
import RxSwift
import RxDataSources
import UtilityModule
import BaseFeatureInterface


class BookMarkDetailViewController: UIViewController {

    var viewModel: BookMarkDetailViewModel!
    var editModalFactory: any EditModalFactory
    
    let disposeBag = DisposeBag()
    let input = BookMarkDetailViewModel.Input()
    
    lazy var naviTitleView: UIView = UIView()
    lazy var backButton: UIButton = UIButton().then {
    
        $0.setImage(DesignSystemAsset.Icon.back.image, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFill
    }
    //TODO: 이미지 교체 
    lazy var editButton: UIButton = UIButton().then{
        $0.setImage(DesignSystemAsset.Icon.pencil.image, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
    }
    
    
    lazy var naviTitleLabel: AlleyLabel = AlleyLabel()
    
    
    lazy var countLabel: AlleyLabel = AlleyLabel()
    
    
    lazy var emptyHeaderView: EmptyTableHeaderView = EmptyTableHeaderView(frame: CGRect(x: .zero, y: .zero, width: APP_WIDTH(), height: 80), text: "아직 저장목록이 없어요.")
    
    lazy var tableView :UITableView = UITableView().then {
        $0.register(BookMarkDetailTableViewCell.self, forCellReuseIdentifier: BookMarkDetailTableViewCell.identifier)
        $0.separatorStyle = .none
    }
    
    lazy var baseLine: UIView = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.1)
    }
    

    
    init(editModalFactory: EditModalFactory, viewModel: BookMarkDetailViewModel!) {
        DEBUG_LOG("\(Self.self) Init ✅ ")
        self.editModalFactory = editModalFactory
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        NotificationCenter.default.post(name: .refreshBookMarkGroup, object: nil)
        DEBUG_LOG("\(Self.self) Denit ❌ ")
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCommonUI()
        addSubviews()
        makeConstraints()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureSwipeBack()
    }
    
}

extension BookMarkDetailViewController {
    
    
    func addSubviews() {
        self.view.addSubviews(naviTitleView, countLabel, baseLine, tableView)
        naviTitleView.addSubviews(backButton, naviTitleLabel,editButton)
    }
    
    func makeConstraints() {
        naviTitleView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide).inset(12)
            $0.height.equalTo(32)
        }
        
        backButton.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        naviTitleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        countLabel.snp.makeConstraints {
            $0.top.equalTo(naviTitleView.snp.bottom).offset(5)
            $0.horizontalEdges.equalToSuperview()
        }
        
        editButton.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(24)
        }
        
        baseLine.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.equalTo(countLabel.snp.bottom).offset(21)
            $0.horizontalEdges.equalToSuperview()
        }
        
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(baseLine.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
        
        
    }
    
    func bindViewModel() {
       
        let output = self.viewModel.transform(input: input)
        
        bindViewDidLoad(input: input)
        bindBackButton()
        bindEditButton()
        bindRefresh(input: input)
        ///bind Output
        bindDataSource(input: input, output: output)
        bindItemSelected(output: output)
        bindShowToast(input: input, output: output)
    }


}


extension BookMarkDetailViewController: BookMarkDetailTableViewCellDelegate {
    
    func tapBookMark(id: Int?) {
        guard let id = id as? Int else {
            return
        }
        
        input.removePrintShop.onNext(id)
    }

    
}
