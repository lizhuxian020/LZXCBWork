//
//  CBPetFuncCvsationView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/1.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetFuncCvsationView: CBPetBaseView,UITableViewDelegate, UITableViewDataSource {

    private lazy var petCvsationTableView:UITableView = {
        let tableV:UITableView = UITableView(frame: CGRect.zero, style: .plain)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.backgroundColor = KPetBgmColor
        tableV.separatorStyle = .none
        tableV.register(CBPetFuncLeftCvstionCell.self, forCellReuseIdentifier: "CBPetFuncLeftCvstionCell")
        tableV.register(CBPetFuncRightCvstionCell.self, forCellReuseIdentifier: "CBPetFuncRightCvstionCell")
        tableV.estimatedRowHeight = 61*KFitHeightRate
        tableV.rowHeight = UITableView.automaticDimension
        tableV.mj_footer = MJRefreshBackNormalFooter()
        tableV.mj_footer.setRefreshingTarget(self, refreshingAction: #selector(pullFooterRefreshData))
        return tableV
    }()
    public lazy var footView:CBPetFuncCvstionFootView = {
        let footV = CBPetFuncCvstionFootView.init()
        return footV
    }()
    private lazy var arrayDataSource:[CBPetFuncCvstionModel] = {
        var arr = [CBPetFuncCvstionModel]()
        return arr
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollToBottom()
    }
    override func setupViewModel(viewModel: Any) {
        self.viewModel = viewModel
        self.footView.setupViewModel(viewModel: self.viewModel)
        self.petCvsationTableView.reloadData()
    }
    private func scrollToBottom() {
        /* 滚动至底部*/
        let section = self.petCvsationTableView.numberOfSections
        if section < 1 { return }
        let row = self.petCvsationTableView.numberOfRows(inSection: section - 1)
        if row < 1 { return }
        let indexPath = IndexPath(row: row - 1, section: section - 1)
        self.petCvsationTableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: false)
    }
    
    private func setupView() {
        self.backgroundColor = KPetBgmColor
        self.addSubview(self.petCvsationTableView)
        self.petCvsationTableView.snp_makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(0)
            make.bottom.equalTo(-50*KFitHeightRate-TabPaddingBARHEIGHT)
        }
        self.addSubview(self.footView)
        self.footView.snp_makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(self.petCvsationTableView.snp_bottom).offset(0)
            make.bottom.equalTo(100*KFitHeightRate)
        }
    }
    @objc private func pullHeaderRefreshData() {
        let vvModel = self.viewModel as! CBPetFuncChatViewModel
        guard vvModel.MJHeaderRefreshReloadDataBlock == nil else {
            vvModel.MJHeaderRefreshReloadDataBlock!(2020)
            return
        }
    }
    @objc private func pullFooterRefreshData() {
        let vvModel = self.viewModel as! CBPetFuncChatViewModel
        guard vvModel.MJFooterRefreshReloadDataBlock == nil else {
            vvModel.MJFooterRefreshReloadDataBlock!(2020)
            return
        }
    }
    func beginRefresh() {
        self.petCvsationTableView.mj_footer.beginRefreshing()
    }
    func endRefresh() {
        self.petCvsationTableView.mj_footer.endRefreshing()
    }
    func refresh() {
        self.petCvsationTableView.reloadData()
    }
    func updateChatData(dataSource:[CBPetFuncCvstionModel]) {
        self.arrayDataSource = dataSource
        self.petCvsationTableView.reloadData()
        self.scrollToBottom()
    }
    func cleanInputMsg() {
        self.footView.cleanInputMsg()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayDataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CBPetFuncLeftCvstionCell") as! CBPetFuncLeftCvstionCell
        let mySelfCell = tableView.dequeueReusableCell(withIdentifier: "CBPetFuncRightCvstionCell") as! CBPetFuncRightCvstionCell
        if self.arrayDataSource.count > indexPath.row {
            let model = self.arrayDataSource[indexPath.row] as CBPetFuncCvstionModel
            if model.sendd_my_self == "1" {
                mySelfCell.setupViewModel(viewModel: self.viewModel)
                mySelfCell.cvstionModel = model
                return mySelfCell
            } else if model.sendd_my_self == "0" {
                cell.setupViewModel(viewModel: self.viewModel)
                cell.cvstionModel = model
                if self.viewModel is CBPetFuncChatViewModel {
                    let vvModel = self.viewModel as! CBPetFuncChatViewModel
                    cell.petFriendMsgModel = vvModel.petFriendMsgModel ?? CBPetFuncPetFriendsMsgModel()
                }
                return cell
            }
        }
        return UITableViewCell.init()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if self.viewModel is CBPetFuncChatViewModel {
//            guard (self.viewModel as! CBPetFuncChatViewModel).petfriendDetailBlock == nil else {
//                (self.viewModel as! CBPetFuncChatViewModel).petfriendDetailBlock!()
//                return
//            }
//        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
