//
//  CBPetPsnalPetInfoView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/3.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetPsnalPetInfoView: CBPetBaseView,UITableViewDelegate, UITableViewDataSource {

    private lazy var petInfoTableView:UITableView = {
        let tableV:UITableView = UITableView(frame: CGRect.zero, style: .plain)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.backgroundColor = KPetBgmColor
        tableV.separatorStyle = .none
        tableV.estimatedRowHeight = 52*KFitHeightRate
        tableV.rowHeight = UITableView.automaticDimension
        tableV.register(CBPetPsnalPetInfoTabCell.self, forCellReuseIdentifier: "CBPetPsnalPetInfoTabCell")
        tableV.register(CBPetPsnalPetInfoDeviceTabCell.self, forCellReuseIdentifier: "CBPetPsnalPetInfoDeviceTabCell")
        return tableV
    }()
    private lazy var arrayDataSource:[CBPetPsnalCterPetPet] = {
        let arr = [CBPetPsnalCterPetPet]()
        return arr
    }()
    private lazy var footerView:CBPetBaseView = {
        let view:CBPetBaseView = CBPetBaseView(frame:CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 62*KFitHeightRate))///116
        view.backgroundColor = KPetBgmColor
        return view
    }()
//    private lazy var titleLb:UILabel = {
//        let lb = UILabel(text: "关联设备".localizedStr, textColor: KPetTextColor, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!,textAlignment: .left)
//        return lb
//    }()
//    private lazy var textLb:UILabel = {
//        let lb = UILabel(text: "D4E6C4".localizedStr, textColor: KPet999999Color, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!,textAlignment: .right)
//        return lb
//    }()
    private lazy var deleteDeviceBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton(title: "解除设备".localizedStr, titleColor: KPetAppColor, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!)
        btn.backgroundColor = UIColor.white
        return btn
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
        self.petInfoTableView.reloadData()
    }
    private func setupView() {
        self.addSubview(self.petInfoTableView)
        self.petInfoTableView.snp_makeConstraints { (make) in
            make.left.right.top.equalTo(self)
            make.bottom.equalTo(-TabPaddingBARHEIGHT-62*KFitHeightRate)
        }
        setupFootView()
        let arrayTitle = ["头像".localizedStr,"昵称".localizedStr,"品种".localizedStr,
                          "性别".localizedStr,"毛色".localizedStr,"宠龄".localizedStr,"防疫记录".localizedStr,"关联设备".localizedStr]
        for index in 0..<arrayTitle.count {
            var model = CBPetPsnalCterPetPet()
            model.title = arrayTitle[index]
            model.text = ""
            self.arrayDataSource.append(model)
        }
    }
    private func setupFootView() {
        self.addSubview(self.footerView)
        self.footerView.snp_makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.bottom.equalTo(-TabPaddingBARHEIGHT)
            make.height.equalTo(62*KFitHeightRate)
        }
//        let whiteView = UIView.init()
//        whiteView.backgroundColor = UIColor.white
//        self.footerView.addSubview(whiteView)
//        whiteView.snp_makeConstraints { (make) in
//            make.top.equalTo(self.footerView.snp_top).offset(10*KFitHeightRate)
//            make.left.right.equalTo(0*KFitWidthRate)
//            make.height.equalTo(52*KFitHeightRate)
//        }
        
        
//        whiteView.addSubview(self.titleLb)
//        self.titleLb.snp_makeConstraints { (make) in
//            make.centerY.equalTo(whiteView)
//            make.left.equalTo(20*KFitWidthRate)
//        }
//        whiteView.addSubview(self.textLb)
//        self.textLb.snp_makeConstraints { (make) in
//            make.centerY.equalTo(whiteView)
//            make.right.equalTo(-20*KFitWidthRate)
//        }
        
//        self.footerView.addSubview(self.deleteDeviceBtn)
//        self.deleteDeviceBtn.snp_makeConstraints { (make) in
//            make.top.equalTo(whiteView.snp_bottom).offset(10*KFitHeightRate)
//            make.left.right.bottom.equalTo(0*KFitWidthRate)
//        }
        self.footerView.addSubview(self.deleteDeviceBtn)
        self.deleteDeviceBtn.snp_makeConstraints { (make) in
            //make.left.right.top.bottom.equalTo(whiteView)
            make.top.equalTo(self.footerView.snp_top).offset(10*KFitHeightRate)
            make.left.right.equalTo(0*KFitWidthRate)
            make.height.equalTo(52*KFitHeightRate)
        }
        self.deleteDeviceBtn.addTarget(self, action: #selector(deleteDeviceClick), for: .touchUpInside)
    }
    @objc private func deleteDeviceClick() {
        CBLog(message: "解除设备 解除设备 解除设备 解除设备")
        if self.viewModel is CBPetPsnalCterViewModel {
            (self.viewModel as! CBPetPsnalCterViewModel).pushBlock!("解除设备".localizedStr)
        }
    }
    //MARK: - 更新宠物信息
    func updatePetsInfoData(petInfoModel:CBPetPsnalCterPetPet) {
        let arrayTitle = ["头像".localizedStr,"昵称".localizedStr,"品种".localizedStr,
        "性别".localizedStr,"毛色".localizedStr,"宠龄".localizedStr,"防疫记录".localizedStr,"关联设备".localizedStr]
        let arrayText = [petInfoModel.photo,petInfoModel.name ?? "",petInfoModel.variety ?? "",
                         petInfoModel.sex,petInfoModel.color,petInfoModel.age,petInfoModel.epidemicRecord,petInfoModel.device.imei]
        for index in 0..<self.arrayDataSource.count {
            self.arrayDataSource[index] = petInfoModel
            self.arrayDataSource[index].title = arrayTitle[index]
            self.arrayDataSource[index].text = arrayText[index]
        }
        self.petInfoTableView.reloadData()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayDataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CBPetPsnalPetInfoTabCell") as! CBPetPsnalPetInfoTabCell
        let deviceCell = tableView.dequeueReusableCell(withIdentifier: "CBPetPsnalPetInfoDeviceTabCell") as! CBPetPsnalPetInfoDeviceTabCell
        if self.arrayDataSource.count > indexPath.row {
            if indexPath.row == self.arrayDataSource.count-1 {
                deviceCell.petInfoModel = self.arrayDataSource[indexPath.row]
                return deviceCell
            } else {
                cell.petInfoModel = self.arrayDataSource[indexPath.row]
                return cell
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.arrayDataSource.count > indexPath.row && indexPath.row != self.arrayDataSource.count-1 {
            if self.viewModel is CBPetPsnalCterViewModel {
                (self.viewModel as! CBPetPsnalCterViewModel).pushBlock!(self.arrayDataSource[indexPath.row])
            }
        }
    }
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        return self.footerView
//    }
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 62*KFitHeightRate///116*KFitHeightRate
//    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
