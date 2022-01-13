//
//  CBPetFuncChatPetInfoView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/2.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetFuncChatPetInfoView: CBPetBaseView,UITableViewDelegate, UITableViewDataSource {

    private lazy var petInfoTableView:UITableView = {
        let tableV:UITableView = UITableView(frame: CGRect.zero, style: .plain)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.backgroundColor = KPetBgmColor
        tableV.separatorStyle = .none
        tableV.estimatedRowHeight = 52*KFitHeightRate
        tableV.rowHeight = UITableView.automaticDimension
        tableV.register(CBPetFuncChatPetInfoTabCell.self, forCellReuseIdentifier: "CBPetFuncChatPetInfoTabCell")
        return tableV
    }()
    private lazy var arrayDataSource:[CBPetPsnalCterPetPet] = {
        let arr = [CBPetPsnalCterPetPet]()
        return arr
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupView() {
        self.addSubview(self.petInfoTableView)
        self.petInfoTableView.snp_makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self)
        }
        let arrayTitle = ["头像".localizedStr,"昵称".localizedStr,"品种".localizedStr,
                          "性别".localizedStr,"毛色".localizedStr,"宠龄".localizedStr,"防疫记录".localizedStr]
        for index in 0..<arrayTitle.count {
            var model = CBPetPsnalCterPetPet()
            model.title = arrayTitle[index]
            model.text = ""
            self.arrayDataSource.append(model)
        }
    }
    //MARK: - 更新宠物信息
    func updatePetsInfoData(petInfoModel:CBPetPsnalCterPetPet) {
        let arrayTitle = ["头像".localizedStr,"昵称".localizedStr,"品种".localizedStr,
        "性别".localizedStr,"毛色".localizedStr,"宠龄".localizedStr,"防疫记录".localizedStr]
        let arrayText = [petInfoModel.photo,petInfoModel.name ?? "",petInfoModel.variety ?? "",
                         petInfoModel.sex,petInfoModel.color,petInfoModel.age,petInfoModel.epidemicRecord]
        for index in 0..<self.arrayDataSource.count {
            self.arrayDataSource[index] = petInfoModel
            self.arrayDataSource[index].title = arrayTitle[index]
            self.arrayDataSource[index].text = arrayText[index]
            self.arrayDataSource[index].epidemicImage = petInfoModel.epidemicImage
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CBPetFuncChatPetInfoTabCell") as! CBPetFuncChatPetInfoTabCell
        if self.arrayDataSource.count > indexPath.row {
            let model = self.arrayDataSource[indexPath.row]
            cell.petInfoModel = model
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
