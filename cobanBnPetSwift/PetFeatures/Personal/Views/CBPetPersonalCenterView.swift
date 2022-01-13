//
//  CBPetPersonalCenterView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/3.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetPersonalCenterView: CBPetBaseView,UITableViewDelegate, UITableViewDataSource {

    private lazy var psnalTableView:UITableView = {
        let tableV:UITableView = UITableView(frame: CGRect.zero, style: .plain)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.backgroundColor = UIColor.white
        tableV.separatorStyle = .none
        tableV.estimatedRowHeight = 53*KFitHeightRate
        tableV.rowHeight = UITableView.automaticDimension
        tableV.register(CBPetPsnalCenterHeadTabCell.self, forCellReuseIdentifier: "CBPetPsnalCenterHeadTabCell")
        tableV.register(CBPetPsnalCterPetlistTabCell.self, forCellReuseIdentifier: "CBPetPsnalCterPetlistTabCell")
        tableV.register(CBPetPsnalCterTableViewCell.self, forCellReuseIdentifier: "CBPetPsnalCterTableViewCell")
        return tableV
    }()
    private lazy var arrayDataSource:[CBPetPsnalCterModel] = {
        let arr = [CBPetPsnalCterModel]()
        return arr
    }()
    override func setupViewModel(viewModel: Any) {
        self.viewModel = viewModel
        if self.viewModel is CBPetPsnalCterViewModel {
            self.psnalTableView.reloadData()
        }
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
        
        self.addSubview(self.psnalTableView)
        self.psnalTableView.snp_makeConstraints { (make) in
            make.left.right.bottom.top.equalTo(self) //top
            //make.top.equalTo(-NavigationBarHeigt)
        }

////        if (@available(iOS 11.0, *)) {
////            self.psnalTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever
////        }
//        self.psnalTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever
        
//        let headView = CBPetChatPetfriendHdView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: NavigationBarHeigt))
//        headView.backgroundColor = UIColor.white
//        headView.leftTitleValue = "".localizedStr
//        headView.rightTitleValue = "".localizedStr
//        self.psnalTableView.tableHeaderView = headView
        
        let arrayTitle = ["","","系统切换".localizedStr,"信息通知".localizedStr,
                          "修改密码".localizedStr,"清除缓存".localizedStr,
                          "关于我们".localizedStr,"退出登录".localizedStr]
        let arrayText = ["","","巴诺宠物项圈","","",CBPetUtils.getCacheSize(),"",""]
        for index in 0..<arrayTitle.count {
            var model = CBPetPsnalCterModel()
            model.title = arrayTitle[index]
            model.text = arrayText[index]
            self.arrayDataSource.append(model)
        }
    }
    func updateUserInfo() {
        let switchModel = CBPetSwitchSystemTool.getSwitchModel()
        var appPushStr = UserDefaults.standard.object(forKey: "appPush")
        if appPushStr == nil {
            appPushStr = ""
        }
        for index in 0..<self.arrayDataSource.count {
            if self.arrayDataSource[index].title == "系统切换".localizedStr {
                self.arrayDataSource[index].text = switchModel.title == nil ? "巴诺宠物".localizedStr : switchModel.title?.localizedStr
            }
            if self.arrayDataSource[index].title == "信息通知".localizedStr {
                self.arrayDataSource[index].isOn = appPushStr as? String
            }
            if self.arrayDataSource[index].title == "清除缓存".localizedStr {
                self.arrayDataSource[index].text = CBPetUtils.getCacheSize()
            }
        }
        self.psnalTableView.reloadRows(at: [IndexPath(row: 2, section: 0),IndexPath(row: 3, section: 0),IndexPath(row: 5, section: 0)], with: UITableView.RowAnimation.none) 
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayDataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "CBPetPsnalCenterHeadTabCell") as! CBPetPsnalCenterHeadTabCell
        let petListCell = tableView.dequeueReusableCell(withIdentifier: "CBPetPsnalCterPetlistTabCell") as! CBPetPsnalCterPetlistTabCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "CBPetPsnalCterTableViewCell") as! CBPetPsnalCterTableViewCell
        if indexPath.row == 0 {
            if self.viewModel is CBPetPsnalCterViewModel {
                headerCell.setupViewModel(viewModel: self.viewModel)
            }
            return headerCell
        } else if indexPath.row == 1 {
            if self.viewModel is CBPetPsnalCterViewModel {
                petListCell.setupViewModel(viewModel: self.viewModel)
            }
            return petListCell
        } else {
            if self.viewModel is CBPetPsnalCterViewModel {
                cell.setupViewModel(viewModel: self.viewModel)
            }
            if self.arrayDataSource.count > indexPath.row {
                let model = self.arrayDataSource[indexPath.row]
                cell.psnalModel = model
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.viewModel is CBPetPsnalCterViewModel {
            let vvModel = self.viewModel as! CBPetPsnalCterViewModel
            switch indexPath.row {
            case 2:
                if vvModel.psnlCterClickBlock != nil {
                    vvModel.psnlCterClickBlock!(CBPetPsnalCterClickType.switchSystem,"")
                }
                break
            case 3:
                break
            case 4:
                if vvModel.psnlCterClickBlock != nil {
                    vvModel.psnlCterClickBlock!(CBPetPsnalCterClickType.modifyPwd,"")
                }
                break
            case 5:
                if vvModel.psnlCterClickBlock != nil {
                    vvModel.psnlCterClickBlock!(CBPetPsnalCterClickType.cleanCache,"")
                }
                break
            case 6:
                if vvModel.psnlCterClickBlock != nil {
                    vvModel.psnlCterClickBlock!(CBPetPsnalCterClickType.aboutUs,"")
                }
                break
            case 7:
                if vvModel.psnlCterClickBlock != nil {
                    vvModel.psnlCterClickBlock!(CBPetPsnalCterClickType.logout,"")
                }
            break
            default:
                break
            }
        }
    }
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.y > -NavPaddingBARHEIGHT {
//            self.psnalTableView.setContentOffset(CGPoint(x: 0, y: -NavigationBarHeigt), animated: false)
//        }
//    }
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.y > -NavPaddingBARHEIGHT {
//            self.psnalTableView.setContentOffset(CGPoint(x: 0, y: -NavigationBarHeigt), animated: false)
//        }
//    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        CBLog(message: "tableView偏移量")
        CBLog(message: scrollView.contentOffset)
//        if scrollView.contentOffset.y > -NavPaddingBARHEIGHT {
//            self.psnalTableView.setContentOffset(CGPoint(x: 0, y: -NavigationBarHeigt), animated: true)
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
