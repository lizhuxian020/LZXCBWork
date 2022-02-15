//
//  CBPetFuncUserManageView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/5/30.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetFuncUserManageView: CBPetBaseView, UITableViewDelegate, UITableViewDataSource {

    private lazy var shadowBgmView:UIView = {
        let bgmV = UIView(backgroundColor: UIColor.white, cornerRadius: 16*KFitHeightRate, shadowColor: KPetC8C8C8Color, shadowOpacity: 0.85, shadowOffset: CGSize(width: 0, height: 0), shadowRadius: 5)
        return bgmV
    }()
    private lazy var headView:CBPetFuncUserManageHeadView = {
        let headV = CBPetFuncUserManageHeadView.init(frame: CGRect.init(x: 20*KFitWidthRate, y: 10*KFitHeightRate, width: SCREEN_WIDTH - 40*KFitWidthRate, height: 92*KFitHeightRate))//CBPetFuncUserManageHeadView.init()
        headV.layer.cornerRadius = 16*KFitHeightRate
        headV.backgroundColor = UIColor.white
        return headV
    }()
    private lazy var configView : CBPetFuncUserManageOtherConfigView = {
        let v = CBPetFuncUserManageOtherConfigView.init()
        return v
    }()
    private lazy var userManageTableView:UITableView = {
        let tableV:UITableView = UITableView(frame: CGRect.zero, style: .plain)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.backgroundColor = UIColor.white
        tableV.separatorStyle = .none
        tableV.register(CBPetFuncUserManagerCell.self, forCellReuseIdentifier: "CBPetFuncUserManagerCell")
        tableV.mj_header = MJRefreshStateHeader()
        tableV.mj_header.setRefreshingTarget(self, refreshingAction: #selector(pullHeaderRefreshData))
        return tableV
    }()
    private lazy var addUserBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton(title: "添加用户管理".localizedStr, titleColor: UIColor.white, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!)
        btn.setShadow(backgroundColor: KPetAppColor, cornerRadius: 20*KFitHeightRate, shadowColor: KPetAppColor, shadowOpacity: 0.35, shadowOffset: CGSize(width: 4, height: 0), shadowRadius: 8)
        return btn
    }()
    private lazy var arrayDataSource:[CBPetUserManageModel] = {
        let arr = [CBPetUserManageModel]()
        return arr
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setupViewModel(viewModel: Any) {
        self.viewModel = viewModel
        self.configView.setupViewModel(viewModel: self.viewModel)
        self.userManageTableView.reloadData()
        if self.viewModel is CBPetUserManageViewModel {
            let vvModel = self.viewModel as! CBPetUserManageViewModel
            vvModel.userManageUpdateListDataBlock = { [weak self] (dataSource:[CBPetUserManageModel]) -> Void in
                ///刷新数据
                self?.arrayDataSource = dataSource
                self?.userManageTableView.reloadData()
            }
            vvModel.userMangerUpdateParamModelBlock = {[weak self] (paramModel : CBPetHomeParamtersModel) -> Void in
                self?.configView.configModel = paramModel
            }
            self.userManageTableView.isHidden = !(vvModel.isAdmin == true)
            self.addUserBtn.isHidden = self.userManageTableView.isHidden
        }
    }
    private func setupView() {
        self.backgroundColor = UIColor.white
        self.addSubview(self.shadowBgmView)
        self.shadowBgmView.snp_makeConstraints { (make) in
            make.top.equalTo(10*KFitHeightRate)
            make.left.equalTo(20*KFitWidthRate)
            make.size.equalTo(CGSize(width: SCREEN_WIDTH - 40*KFitWidthRate, height: 92*KFitHeightRate))
        }
        self.addSubview(self.headView)
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(fingerTap))
        self.headView.addGestureRecognizer(tapGesture)
        
        self.addSubview(self.configView)
        configView.snp_makeConstraints { make in
            make.left.equalTo(20*KFitWidthRate)
            make.right.equalTo(-20*KFitWidthRate)
            make.top.equalTo(self.headView.snp_bottom).offset(10*KFitHeightRate)
        }
        
        self.addSubview(self.userManageTableView)
        self.userManageTableView.snp_makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self.configView.snp_bottom).offset(10*KFitHeightRate)
            make.bottom.equalTo(-70*KFitHeightRate - TabPaddingBARHEIGHT)
        }
        
        self.addSubview(self.addUserBtn)
        self.addUserBtn.snp_makeConstraints { (make) in
            make.left.equalTo(50*KFitWidthRate)
            make.right.equalTo(-50*KFitWidthRate)
            make.bottom.equalTo(-20*KFitHeightRate - TabPaddingBARHEIGHT)
            make.height.equalTo(40*KFitHeightRate)
        }
        self.addUserBtn.addTarget(self, action: #selector(addUserManageClick), for: .touchUpInside)
    }
    @objc private func addUserManageClick() {
        let addVC = CBPetFuncAddUserManageVC.init()
        UIViewController.getCurrentVC()?.navigationController?.pushViewController(addVC, animated: true)
    }
    @objc private func pullHeaderRefreshData() {
        let vvModel = self.viewModel as! CBPetUserManageViewModel
        guard vvModel.MJHeaderRefreshReloadDataBlock == nil else {
            vvModel.MJHeaderRefreshReloadDataBlock!(2020)
            return
        }
    }
    @objc private func pullFooterRefreshData() {
        let vvModel = self.viewModel as! CBPetUserManageViewModel
        guard vvModel.MJFooterRefreshReloadDataBlock == nil else {
            vvModel.MJFooterRefreshReloadDataBlock!(2020)
            return
        }
    }
    func beginRefresh() {
        self.userManageTableView.mj_header.beginRefreshing()
    }
    func endRefresh() {
        self.userManageTableView.mj_header.endRefreshing()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayDataSource.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76*KFitHeightRate
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CBPetFuncUserManagerCell") as! CBPetFuncUserManagerCell
        cell.setupViewModel(viewModel: self.viewModel)
        if self.arrayDataSource.count > indexPath.row {
            let model = self.arrayDataSource[indexPath.row]
            cell.userManageModel = model
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
    ///MARK: - 跳转宠物资料
    @objc private func fingerTap(gestureRecognizer:UITapGestureRecognizer) {
        if self.viewModel is CBPetUserManageViewModel {
            let vvModel = self.viewModel as! CBPetUserManageViewModel
            guard vvModel.pushBlock == nil else {
                vvModel.pushBlock!("")
                return
            }
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
