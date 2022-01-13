//
//  CBPetPsnalCterPrivcSettingView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/3.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetPsnalCterPrivcSettingView: CBPetBaseView,UITableViewDelegate, UITableViewDataSource {

    private lazy var headerView:UIView = {
        let vv = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: (32+21+16)*KFitHeightRate))
        vv.backgroundColor = KPetBgmColor
        return vv
    }()
    private lazy var privacyTableView:UITableView = {
        let tableV:UITableView = UITableView(frame: CGRect.zero, style: .plain)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.backgroundColor = UIColor.white
        tableV.separatorStyle = .none
        tableV.estimatedRowHeight = 65*KFitHeightRate
        tableV.rowHeight = UITableView.automaticDimension
        tableV.register(CBPetPsnalPrivcTableViewCell.self, forCellReuseIdentifier: "CBPetPsnalPrivcTableViewCell")
        return tableV
    }()
    private lazy var arrayDataSouce:[Any] = {
        let arr = [Any]()
        return arr
    }()
    override func setupViewModel(viewModel: Any) {
        self.viewModel = viewModel
        self.privacyTableView.reloadData()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupView() {
        self.backgroundColor = UIColor.white
        
        self.addSubview(self.privacyTableView)
        self.privacyTableView.snp_makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self)
        }
        
        self.setupHeadView()
    }
    private func setupHeadView() {
        let titleLb = UILabel(text: "允许展示的模块".localizedStr, textColor: KPet999999Color, font: UIFont(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!, textAlignment: .left)
        self.headerView.addSubview(titleLb)
        titleLb.snp_makeConstraints { (make) in
            make.top.equalTo(10*KFitHeightRate)
            make.left.equalTo(20*KFitWidthRate)
        }
        
        let whiteView = UIView.init()
        whiteView.backgroundColor = UIColor.white
        self.headerView.addSubview(whiteView)
        whiteView.snp_makeConstraints { (make) in
            make.top.equalTo(titleLb.snp_bottom).offset(10*KFitHeightRate)
            make.left.right.bottom.equalTo(0*KFitWidthRate)
        }
        
        let noteLb = UILabel(text: "是否公开宠物位置找好友".localizedStr, textColor: KPetTextColor, font: UIFont(name: CBPingFangSC_Regular, size: 16*KFitHeightRate)!, textAlignment: .left)
        whiteView.addSubview(noteLb)
        noteLb.snp_makeConstraints { (make) in
            make.bottom.equalTo(whiteView.snp_bottom).offset(0)
            make.left.equalTo(20*KFitWidthRate)
        }
    }
    func updatePrivacyData(dataSource:[Any]) {
        self.arrayDataSouce = dataSource
        
        let arrayTitle = ["电话".localizedStr,"微信".localizedStr,"邮箱".localizedStr,"WhatsApp".localizedStr]
        for index in 0..<arrayTitle.count {
            var model = CBPetUserInfoModel()
            model.title = arrayTitle[index]
            switch index {
            case 0:
                model.isPublishPhone = CBPetUserInfoModelTool.getUserInfo().isPublishPhone
                break
            case 1:
                model.isPublishWeixin = CBPetUserInfoModelTool.getUserInfo().isPublishWeixin
                break
            case 2:
                model.isPublishEmail = CBPetUserInfoModelTool.getUserInfo().isPublishEmail
                break
            case 3:
                model.isPublishWhatsapp = CBPetUserInfoModelTool.getUserInfo().isPublishWhatsapp
                break
            default:
                break
            }
            self.arrayDataSouce.append(model)
        }
        self.privacyTableView.reloadData()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayDataSouce.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CBPetPsnalPrivcTableViewCell") as! CBPetPsnalPrivcTableViewCell
//        if self.viewModel is CBPetBaseViewModel {
//            cell.setupViewModel(viewModel: self.viewModel)
//        }
        cell.updateBlock = { [weak self] () -> Void in
            //self?.updatePrivacyData(dataSource: self!.arrayDataSouce)
        }
        if self.arrayDataSouce.count > indexPath.row {
            if indexPath.row == self.arrayDataSouce.count - 1
            || indexPath.row == self.arrayDataSouce.count - 2
            || indexPath.row == self.arrayDataSouce.count - 3
            || indexPath.row == self.arrayDataSouce.count - 4 {
                var model = self.arrayDataSouce[indexPath.row] as! CBPetUserInfoModel
                model.cout = self.arrayDataSouce.count
                model.index = indexPath.row
                cell.type = "1"
                cell.privacyUserInfoModel = model
            } else {
                var model = self.arrayDataSouce[indexPath.row] as! CBPetPsnalCterPetModel
                model.cout = self.arrayDataSouce.count
                model.index = indexPath.row
                cell.type = "2"
                cell.privacyPetModel = model
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.arrayDataSouce.count == 4 || self.arrayDataSouce.count == 0 {
            return 0
        }
        return (32+21+16)*KFitHeightRate
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.arrayDataSouce.count == 4 || self.arrayDataSouce.count == 0 {
            return nil
        }
        return self.headerView
    }
    

    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
