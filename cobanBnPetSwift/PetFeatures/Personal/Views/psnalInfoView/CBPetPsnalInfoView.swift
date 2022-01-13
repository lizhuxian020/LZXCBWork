//
//  CBPetPsnalInfoView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/3.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetPsnalInfoView: CBPetBaseView,UITableViewDelegate, UITableViewDataSource {

    private lazy var footerView:UIView = {
        let vv = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: (32+44)*KFitHeightRate))
        vv.backgroundColor = KPetBgmColor
        return vv
    }()
    private lazy var logOutBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton(title: "退出登录".localizedStr, titleColor: KPetAppColor, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!)
        btn.backgroundColor = UIColor.white
        return btn
    }()
    private lazy var psnalInfoTableView:UITableView = {
        let tableV:UITableView = UITableView(frame: CGRect.zero, style: .plain)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.backgroundColor = KPetBgmColor
        tableV.separatorStyle = .none
        tableV.estimatedRowHeight = 65*KFitHeightRate
        tableV.rowHeight = UITableView.automaticDimension
        tableV.register(CBPetPsnalInfoTableViewCell.self, forCellReuseIdentifier: "CBPetPsnalInfoTableViewCell")
        return tableV
    }()
    private lazy var arrayDataSource:[CBPetUserInfoModel] = {
        let arr = [CBPetUserInfoModel]()
        return arr
    }()
    override func setupViewModel(viewModel: Any) {
        self.viewModel = viewModel
        self.psnalInfoTableView.reloadData()
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
        
        self.addSubview(self.psnalInfoTableView)
        self.psnalInfoTableView.snp_makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self)
        }
        
//        self.footerView.addSubview(self.logOutBtn)
//        self.logOutBtn.snp_makeConstraints { (make) in
//            make.left.right.bottom.equalTo(0)
//            make.height.equalTo(44*KFitHeightRate)
//        }
//        self.logOutBtn.addTarget(self, action: #selector(logOutClick), for: .touchUpInside)
        
        let arrayTitle = ["头像".localizedStr,"名字".localizedStr,
                          "性别".localizedStr,"电话".localizedStr,
                          "微信".localizedStr,"邮箱".localizedStr,"WhatsApp".localizedStr]
        let userInfoModelObject = CBPetUserInfoModelTool.getUserInfo()
        let arrayText = [userInfoModelObject.photo,userInfoModelObject.name ?? "",userInfoModelObject.sex ?? "",userInfoModelObject.phone,userInfoModelObject.weixin,userInfoModelObject.email,userInfoModelObject.whatsapp]
        let arrayIsPublish = ["","","",userInfoModelObject.isPublishPhone,userInfoModelObject.isPublishWeixin,userInfoModelObject.isPublishEmail,userInfoModelObject.isPublishWhatsapp]
        for index in 0..<arrayTitle.count {
            var model = CBPetUserInfoModel()
            model.title = arrayTitle[index]
            model.text = arrayText[index]
            model.isPublish = arrayIsPublish[index]
            self.arrayDataSource.append(model)
        }
    }
    public func updateUserInfoData() {
        let userInfoModelObject = CBPetUserInfoModelTool.getUserInfo()
        let arrayText = [userInfoModelObject.photo,userInfoModelObject.name ?? "",userInfoModelObject.sex ?? "",userInfoModelObject.phone,userInfoModelObject.weixin,userInfoModelObject.email,userInfoModelObject.whatsapp]
        let arrayIsPublish = ["","","",userInfoModelObject.isPublishPhone,userInfoModelObject.isPublishWeixin,userInfoModelObject.isPublishEmail,userInfoModelObject.isPublishWhatsapp]
        for index in 0..<self.arrayDataSource.count {
            self.arrayDataSource[index].text = arrayText[index]
            self.arrayDataSource[index].isPublish = arrayIsPublish[index]
        }
        self.psnalInfoTableView.reloadData()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayDataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CBPetPsnalInfoTableViewCell") as! CBPetPsnalInfoTableViewCell
        if self.arrayDataSource.count > indexPath.row {
            let model = self.arrayDataSource[indexPath.row]
            cell.psnalInfoModel = model
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.viewModel is CBPetPsnalCterViewModel {
            let vvModel = self.viewModel as! CBPetPsnalCterViewModel
            //let model = self.arrayDataSource[indexPath.row]
            guard vvModel.psnalCterInputEditInfoBlock == nil else {
                vvModel.psnalCterInputEditInfoBlock!(self.arrayDataSource[indexPath.row])
                return
            }
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return self.footerView
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return (32+44)*KFitHeightRate
    }
    @objc private func logOutClick() {
        if self.viewModel is CBPetPsnalCterViewModel {
            guard (self.viewModel as! CBPetPsnalCterViewModel).pushBlock == nil else {
                (self.viewModel as! CBPetPsnalCterViewModel).pushBlock!("")
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
