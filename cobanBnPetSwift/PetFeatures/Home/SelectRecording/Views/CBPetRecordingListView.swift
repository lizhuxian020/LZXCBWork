//
//  CBPetRecordingListView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/5/28.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetRecordingListView: CBPetBaseView, UITableViewDelegate, UITableViewDataSource {
    
    private lazy var recordingTableView:UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT), style: .plain)
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(CBPetRecordingListCell.self, forCellReuseIdentifier: "CBPetRecordingListCell")
        tableView.mj_header = MJRefreshStateHeader()
        tableView.mj_header.setRefreshingTarget(self, refreshingAction: #selector(pullHeaderRefreshData))
        return tableView
    }()
    private lazy var footView:UIView = {
        let vv = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 53*KFitHeightRate))
        vv.backgroundColor = UIColor.white
        return vv
    }()
    private lazy var addRecordingBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton.init()
        btn.setTitle("添加录音".localizedStr, for: .normal)
        btn.setTitle("添加录音".localizedStr, for: .highlighted)
        btn.setTitleColor(KPetAppColor, for: .normal)
        btn.setTitleColor(KPetAppColor, for: .highlighted)
        btn.titleLabel?.font = UIFont(name: CBPingFang_SC, size: 14*KFitHeightRate)
        return btn
    }()
    private lazy var addRecordingPopView:CBPetAddRecordingPopView = {
        let popV = CBPetAddRecordingPopView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        return popV
    }()
    private lazy var arrayDataSource:[Any] = {
        let arr = Array<Any>()
        return arr
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    override func setupViewModel(viewModel: Any) {
        self.viewModel = viewModel
        self.recordingTableView.reloadData()
        self.addRecordingPopView.setupViewModel(viewModel: self.viewModel)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = UIColor.white
        self.addSubview(self.recordingTableView)
        
        self.footView.addSubview(self.addRecordingBtn)
        self.addRecordingBtn.snp_makeConstraints { (make) in
            make.left.equalTo(self.footView.snp_left).offset(20*KFitWidthRate)
            make.centerY.equalTo(self.footView)
        }
        self.addRecordingBtn.addTarget(self, action: #selector(addReordingClick), for: .touchUpInside)
    }
    @objc private func addReordingClick() {
        if CBPetUtils.checkMicrophonePermission(resultBlock: { [weak self] (isAllow) in
            if isAllow == true {
                /* 询问时点击了允许，然后下一步*/
                self?.addRecordingPopView.popView()
            }
        }) == true {
            self.addRecordingPopView.popView()
        }
    }
    @objc private func pullHeaderRefreshData() {
        let vvModel = self.viewModel as! CBPetHomeViewModel
        guard vvModel.MJHeaderRefreshReloadDataBlock == nil else {
            vvModel.MJHeaderRefreshReloadDataBlock!(2020)
            return
        }
    }
    @objc private func pullFooterRefreshData() {
        let vvModel = self.viewModel as! CBPetHomeViewModel
        guard vvModel.MJFooterRefreshReloadDataBlock == nil else {
            vvModel.MJFooterRefreshReloadDataBlock!(2020)
            return
        }
    }
    func beginRefresh() {
        self.recordingTableView.mj_header.beginRefreshing()
    }
    func endRefresh() {
        self.recordingTableView.mj_header.endRefreshing()
    }
    func updateRecordList(dataSource:[CBPetHomeRcdListModel]) {
        if dataSource.count > 0 {
            self.arrayDataSource = dataSource
        } else {
            self.arrayDataSource.removeAll()
        }
        self.recordingTableView.reloadData()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayDataSource.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 53*KFitHeightRate
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CBPetRecordingListCell") as! CBPetRecordingListCell
        if self.arrayDataSource.count > indexPath.row {
            cell.setupViewModel(viewModel: self.viewModel)
            cell.rcdModel = self.arrayDataSource[indexPath.row] as! CBPetHomeRcdListModel
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.viewModel is CBPetHomeViewModel {
            let vvModel = self.viewModel as! CBPetHomeViewModel
            if (self.arrayDataSource[indexPath.row] as! CBPetHomeRcdListModel).id == vvModel.paramtersObject?.fileRecord.id {
                /* 反选，不设置为选中录音*/
                guard vvModel.petHomeGoHomeRecordBlock == nil else {
                    vvModel.petHomeGoHomeRecordBlock!("selectRcd","-1")
                    return
                }
            } else {
                guard vvModel.petHomeGoHomeRecordBlock == nil else {
                    vvModel.petHomeGoHomeRecordBlock!("selectRcd",self.arrayDataSource[indexPath.row] as! CBPetHomeRcdListModel)
                    return
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return self.footView
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 53*KFitHeightRate
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            ///删除数据
            CBLog(message: "左滑删除")
            if self.arrayDataSource.count > indexPath.row {
                if self.viewModel is CBPetHomeViewModel {
                    let vvModel = self.viewModel as! CBPetHomeViewModel
                    if (self.arrayDataSource[indexPath.row] as! CBPetHomeRcdListModel).id == vvModel.paramtersObject?.fileRecord.id {
                        /* 选中的录音不能删除*/
                        MBProgressHUD.showMessage(Msg: "选中的录音不可删除".localizedStr, Deleay: 1.5)
                    } else {
                        guard vvModel.petHomeGoHomeRecordBlock == nil else {
                            vvModel.petHomeGoHomeRecordBlock!("delete",self.arrayDataSource[indexPath.row] as! CBPetHomeRcdListModel)
                            return
                        }
                    }
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除".localizedStr
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
