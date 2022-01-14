//
//  CBPetSwitchSystemView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/7/13.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetSwitchSystemView: CBPetBaseView,UITableViewDelegate, UITableViewDataSource {

    private lazy var selectTableView:UITableView = {
        let tableV:UITableView = UITableView(frame: CGRect.zero, style: .plain)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.backgroundColor = UIColor.white
        tableV.separatorStyle = .none
        tableV.estimatedRowHeight = 76*KFitHeightRate
        tableV.rowHeight = UITableView.automaticDimension
        tableV.register(CBPetSwitchSystemTabCell.self, forCellReuseIdentifier: "CBPetSwitchSystemTabCell")
        return tableV
    }()
    private lazy var arrayDataSource:[CBPetSwitchSystemModel] = {
        let arr = [CBPetSwitchSystemModel]()
        return arr
    }()
    var clickBlock:(() -> Void)?
    
    override func setupViewModel(viewModel: Any) {
        self.viewModel = viewModel
        
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
        
        self.addSubview(self.selectTableView)
        self.selectTableView.snp_makeConstraints { (make) in
            make.edges.equalTo(0);
        }
        let headView = CBPetChatPetfriendHdView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 28*KFitHeightRate))
        headView.backgroundColor = UIColor.white
        headView.leftTitleValue = "".localizedStr
        headView.rightTitleValue = "".localizedStr
        self.selectTableView.tableHeaderView = headView
        
        let switchModel = CBPetSwitchSystemTool.getSwitchModel()
        let arrayIcon = ["pet_switch_pet","pet_switch_watch",
                         "pet_switch_car"]
        let arrayTitle = ["巴诺宠物".localizedStr,"巴诺手表".localizedStr,
                          "巴诺车联网".localizedStr]
        for index in 0..<arrayTitle.count {
            var model = CBPetSwitchSystemModel()
            model.iconImage = arrayIcon[index]
            model.title = arrayTitle[index]
            if switchModel.title == arrayTitle[index] {
                model.status = true
            }
//            else if arrayTitle[index] == "巴诺宠物".localizedStr && switchModel.title == nil {
//                model.status = true
//            }
            else {
                model.status = false
            }
//            else if switchModel.title == nil && arrayTitle[index] == "巴诺宠物".localizedStr {
//                /*  默认选择的是宠物*/
//                model.status = true
//            }
            self.arrayDataSource.append(model)
        }
    }
    private func updateSwitchData() {
        let switchModel = CBPetSwitchSystemTool.getSwitchModel()
        for index in 0..<self.arrayDataSource.count {
            if switchModel.title == self.arrayDataSource[index].title {
                self.arrayDataSource[index].status = true
            } else {
                self.arrayDataSource[index].status = false
            }
        }
        self.selectTableView.reloadData()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayDataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CBPetSwitchSystemTabCell") as! CBPetSwitchSystemTabCell
        if self.arrayDataSource.count > indexPath.row {
            let model = self.arrayDataSource[indexPath.row]
            cell.switchSystemModel = model
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.arrayDataSource.count > indexPath.row {
            self.arrayDataSource[indexPath.row].status = !self.arrayDataSource[indexPath.row].status
            CBPetSwitchSystemTool.saveSwitchModel(switchModel: self.arrayDataSource[indexPath.row])
            self.updateSwitchData()
            
            switch self.arrayDataSource[indexPath.row].title {
            case "巴诺宠物".localizedStr:
                let notificationName = NSNotification.Name.init(K_SwitchPetRootViewController)
                NotificationCenter.default.post(name: notificationName, object: nil)
                break
            case "巴诺手表".localizedStr:
                let notificationName = NSNotification.Name.init(K_SwitchWtRootViewController)
                NotificationCenter.default.post(name: notificationName, object: nil)
                break
            case "巴诺车联网".localizedStr:
                let notificationName = NSNotification.Name.init(K_SwitchCarNetRootViewController)
                NotificationCenter.default.post(name: notificationName, object: nil)
                break
            default:
                break
            }
            
            if self.clickBlock != nil {
                self.clickBlock!()
            }
        }
    }
}
