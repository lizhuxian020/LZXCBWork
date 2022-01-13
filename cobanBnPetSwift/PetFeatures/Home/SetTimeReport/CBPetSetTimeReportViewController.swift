//
//  CBPetSetTimeReportViewController.swift
//  cobanBnPetSwift
//
//  Created by hsl on 2021/12/12.
//  Copyright © 2021 coban. All rights reserved.
//

import UIKit
import SwiftyJSON

class CBPetSetTimeReportViewController: CBPetBaseViewController,UITableViewDelegate, UITableViewDataSource {

    private lazy var timeReportTableView:UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT), style: .plain)
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(CBPetTimeReportTableViewCell.self, forCellReuseIdentifier: "CBPetTimeReportTableViewCell")
        return tableView
    }()
    private lazy var headerView:UIView = {
        let vv = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 53*KFitHeightRate))
        vv.backgroundColor = UIColor.white
        return vv
    }()
    private lazy var headerLb:UILabel = {
        let lb = UILabel(text: "请添加唤醒时间,选取小时和分钟".localizedStr, textColor: KPet666666Color, font: UIFont(name: CBPingFang_SC, size: 14*KFitHeightRate)!)
        lb.numberOfLines = 0
        headerView.addSubview(lb)
        return lb
    }()
    private lazy var footView:UIView = {
        let vv = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 53*KFitHeightRate))
        vv.backgroundColor = UIColor.white
        return vv
    }()
    private lazy var addRecordingBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton.init()
        btn.setTitle("添加唤醒时间".localizedStr, for: .normal)
        btn.setTitle("添加唤醒时间".localizedStr, for: .highlighted)
        btn.setTitleColor(KPetAppColor, for: .normal)
        btn.setTitleColor(KPetAppColor, for: .highlighted)
        btn.titleLabel?.font = UIFont(name: CBPingFang_SC, size: 14*KFitHeightRate)
        btn.addTarget(self, action: #selector(addWakeUpTime), for: .touchUpInside)
        footView.addSubview(btn)
        return btn
    }()
    private lazy var pickTimePopView:CBPetTimeReportPickTime = {
        let popV = CBPetTimeReportPickTime.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        return popV
    }()
    private lazy var arrayDataSource:[Any] = {
        let arr = Array<Any>()
        return arr
    }()
    
    var timeReportModel = CBPetHomeParamtersModel.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupView()
    }
    private func setupView() {
        self.initBarWith(title: "定时报告".localizedStr, isBack: true)
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.timeReportTableView)
        timeReportTableView.tableFooterView = footView
        
        headerLb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        addRecordingBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        timeReportTableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { [weak self] in
            self?.getTimeReportList()
        })
        
        timeReportTableView.mj_header.beginRefreshing()
    }
    //MARK: - UITableView Delegate Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.timeReportModel.timingReport.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 53*KFitHeightRate
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CBPetTimeReportTableViewCell") as! CBPetTimeReportTableViewCell
        if self.timeReportModel.timingReport.count > indexPath.row {
            self.timeReportModel.timingReport[indexPath.row].index = indexPath.row
            cell.timeReportModel = self.timeReportModel.timingReport[indexPath.row]
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        updateTimeReportRequest(index_path: indexPath)

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
            self.deleteTimeReport(index_path: indexPath)
        }
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除".localizedStr
    }
    
    //MARK: - 添加唤醒时间
    @objc private func addWakeUpTime() {
        self.pickTimePopView.popView()
        self.pickTimePopView.retrunBlock = { [weak self] (hour:String,minute:String) in
            print("添加唤醒时间:%@ %@",hour,minute)
            if self?.timeReportModel.timingReport.count ?? 0 >= 3 {
                MBProgressHUD.showMessage(Msg: "最多只能设置三个时间".localizedStr, Deleay: 2.0)
                return
            }
            self?.addTimeReportRequest(hour: hour, minute: minute)
        }
    }
    //MARK: - request
    func getTimeReportList() {
        var paramters:Dictionary<String,Any> = Dictionary()
        if let value = CBPetHomeInfoTool.getHomeInfo().pet.device.imei {
            paramters["imei"] = value.valueStr
        }
        CBPetNetworkingManager.share.getParamtersByIMEIRequest(paramters: paramters,successBlock: { [weak self] (successModel) in
            guard let self = self else {return}
            self.timeReportTableView.mj_header.endRefreshing()
            let ddJson = JSON.init(successModel.data as Any)
            self.timeReportModel = CBPetHomeParamtersModel.deserialize(from: ddJson.dictionaryObject) ?? CBPetHomeParamtersModel.init()
            self.timeReportTableView.reloadData()
            if self.timeReportModel.timingReport.count > 0 {
                self.timeReportTableView.tableHeaderView = nil
            } else {
                self.timeReportTableView.tableHeaderView = self.headerView
            }
            ///返回错误信息
            guard successModel.status == "0" else {
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 2.0)
                return;
            }
        }, failureBlock: { (failureModel) in
            self.timeReportTableView.mj_header.endRefreshing()
            if self.timeReportModel.timingReport.count > 0 {
                self.timeReportTableView.tableHeaderView = nil
            } else {
                self.timeReportTableView.tableHeaderView = self.headerView
            }
        })
    }
    func addTimeReportRequest(hour:String,minute:String) {
        
        var paramters:Dictionary<String,Any> = Dictionary()
        if let value = CBPetHomeInfoTool.getHomeInfo().pet.device.imei {
            paramters["imei"] = value.valueStr
        }
        if let value = CBPetLoginModelTool.getUser()?.uid {
            paramters["uid"] = value.valueStr
        }

        var paramtersBody:Dictionary<String,Any> = Dictionary()
        paramtersBody["cmd"] = 133

        var jsonDic:Dictionary<String,Any> = Dictionary()
        switch self.timeReportModel.timingReport.count {
        case 0:
            let timeDic:Dictionary<String,Any> = ["timingHour":Int(hour) ?? 0,"timingMinute":Int(minute) ?? 0]
            jsonDic["timingInterval"] = [timeDic]
            break
        case 1:
            let timeDic_01:Dictionary<String,Any> = ["timingHour":Int(self.timeReportModel.timingReport[0].timingHour) ,"timingMinute":Int(self.timeReportModel.timingReport[0].timingMinute)]
            let timeDic_02:Dictionary<String,Any> = ["timingHour":Int(hour) ?? 0 ,"timingMinute":Int(minute) ?? 0]
            jsonDic["timingInterval"] = [timeDic_01,timeDic_02]
            break
        case 2:
            let timeDic_01:Dictionary<String,Any> = ["timingHour":Int(self.timeReportModel.timingReport[0].timingHour),"timingMinute":Int(self.timeReportModel.timingReport[0].timingMinute)]
            let timeDic_02:Dictionary<String,Any> = ["timingHour":Int(self.timeReportModel.timingReport[1].timingHour),"timingMinute":Int(self.timeReportModel.timingReport[1].timingMinute)]
            let timeDic_03:Dictionary<String,Any> = ["timingHour":Int(hour) ?? 0,"timingMinute":Int(minute) ?? 0]
            jsonDic["timingInterval"] = [timeDic_01,timeDic_02,timeDic_03]
            break
        default:
            let timeDic:Dictionary<String,Any> = ["timingHour":Int(hour) ?? 0,"timingMinute":Int(minute) ?? 0]
            jsonDic["timingInterval"] = [timeDic]
            break
        }
        paramtersBody["body"] = CBPetUtils.getJSONStringFromDictionary(dictionary: jsonDic as NSDictionary)

        paramters["body"] = CBPetUtils.getJSONStringFromDictionary(dictionary: paramtersBody as NSDictionary)
        
        MBProgressHUD.showAdded(to: CBPetUtils.getWindow(), animated: true)
        CBPetNetworkingManager.share.commandRequest(paramters: paramters , successBlock: { [weak self] (successModel) in
            guard let self = self else {return}
            MBProgressHUD.hide(for: CBPetUtils.getWindow(), animated: true)
            self.getTimeReportList()
             //返回错误信息
             guard successModel.status == "0" else {
                if successModel.rescode == "0024" {
                    MBProgressHUD.showMessage(Msg: "设备已离线".localizedStr, Deleay: 1.5)
                }  else if successModel.rescode == "0029" {
                    MBProgressHUD.showMessage(Msg: "下发指令超时".localizedStr, Deleay: 1.5)
                }
                 return;
             }
         }) { (failureModel) in
             MBProgressHUD.hide(for: CBPetUtils.getWindow(), animated: true)
         }
    }
    func deleteTimeReport(index_path:IndexPath) {
        var paramters:Dictionary<String,Any> = Dictionary()
        if let value = CBPetHomeInfoTool.getHomeInfo().pet.device.imei {
            paramters["imei"] = value.valueStr
        }
        if let value = CBPetLoginModelTool.getUser()?.uid {
            paramters["uid"] = value.valueStr
        }
        
        var paramtersBody:Dictionary<String,Any> = Dictionary()
        paramtersBody["cmd"] = 133
        
        var jsonDic:Dictionary<String,Any> = Dictionary()
        
        var arr_time = [Any]()
        for (index,model) in timeReportModel.timingReport.enumerated() {
            var timeDic:Dictionary<String,Any> = Dictionary()
            if index != index_path.row {
                timeDic = ["timingHour":Int(model.timingHour),"timingMinute":Int(model.timingMinute)]
                arr_time.append(timeDic)
            }
        }
        jsonDic["timingInterval"] = arr_time
        
        paramtersBody["body"] = CBPetUtils.getJSONStringFromDictionary(dictionary: jsonDic as NSDictionary)
    
        paramters["body"] = CBPetUtils.getJSONStringFromDictionary(dictionary: paramtersBody as NSDictionary)
        
        MBProgressHUD.showAdded(to: CBPetUtils.getWindow(), animated: true)
        CBPetNetworkingManager.share.commandRequest(paramters: paramters , successBlock: { [weak self] (successModel) in
            guard let self = self else {return}
            MBProgressHUD.hide(for: CBPetUtils.getWindow(), animated: true)
            self.getTimeReportList()
             //返回错误信息
             guard successModel.status == "0" else {
                if successModel.rescode == "0024" {
                    MBProgressHUD.showMessage(Msg: "设备已离线".localizedStr, Deleay: 1.5)
                } else if successModel.rescode == "0029" {
                    MBProgressHUD.showMessage(Msg: "下发指令超时".localizedStr, Deleay: 1.5)
                }
                 return;
             }
         }) { (failureModel) in
             MBProgressHUD.hide(for: CBPetUtils.getWindow(), animated: true)
         }
    }
    func updateTimeReportRequest(index_path:IndexPath) {
        
        self.pickTimePopView.popView()
        self.pickTimePopView.retrunBlock = { [weak self] (hour:String,minute:String) in
            print("更改唤醒时间:%@ %@",hour,minute)
            self?.updateTimeReportRequest(hour: hour, minute: minute,index_path: index_path)
        }
    }
    func updateTimeReportRequest(hour: String, minute: String,index_path:IndexPath) {
        var paramters:Dictionary<String,Any> = Dictionary()
        if let value = CBPetHomeInfoTool.getHomeInfo().pet.device.imei {
            paramters["imei"] = value.valueStr
        }
        if let value = CBPetLoginModelTool.getUser()?.uid {
            paramters["uid"] = value.valueStr
        }

        var paramtersBody:Dictionary<String,Any> = Dictionary()
        paramtersBody["cmd"] = 133

        var jsonDic:Dictionary<String,Any> = Dictionary()
        
//        var timeDic_01:Dictionary<String,Any> = ["timingHour":Int(self.timeReportModel.timingReport[0].timingHour),"timingMinute":Int(self.timeReportModel.timingReport[0].timingMinute)]
//        var timeDic_02:Dictionary<String,Any> = ["timingHour":Int(self.timeReportModel.timingReport[1].timingHour),"timingMinute":Int(self.timeReportModel.timingReport[1].timingMinute)]
//        var timeDic_03:Dictionary<String,Any> = ["timingHour":Int(hour) ?? 0,"timingMinute":Int(minute) ?? 0]
        
        switch self.timeReportModel.timingReport.count {
        case 1:
            switch index_path.row {
            case 0:
                let timeDic_01:Dictionary<String,Any> = ["timingHour":Int(hour) ?? 0,"timingMinute":Int(minute) ?? 0]
                jsonDic["timingInterval"] = [timeDic_01]
                break
            default:
                let timeDic:Dictionary<String,Any> = ["timingHour":Int(hour) ?? 0,"timingMinute":Int(minute) ?? 0]
                jsonDic["timingInterval"] = [timeDic]
                break
            }
            break
        case 2:
            switch index_path.row {
            case 0:
                let timeDic:Dictionary<String,Any> = ["timingHour":Int(hour) ?? 0,"timingMinute":Int(minute) ?? 0]
                let timeDic_02:Dictionary<String,Any> = ["timingHour":Int(self.timeReportModel.timingReport[1].timingHour),"timingMinute":Int(self.timeReportModel.timingReport[1].timingMinute)]
                jsonDic["timingInterval"] = [timeDic,timeDic_02]
                break
            case 1:
                let timeDic_01:Dictionary<String,Any> = ["timingHour":Int(self.timeReportModel.timingReport[0].timingHour) ,"timingMinute":Int(self.timeReportModel.timingReport[0].timingMinute)]
                let timeDic_02:Dictionary<String,Any> = ["timingHour":Int(hour) ?? 0 ,"timingMinute":Int(minute) ?? 0]
                jsonDic["timingInterval"] = [timeDic_01,timeDic_02]
                break
            default:
                let timeDic:Dictionary<String,Any> = ["timingHour":Int(hour) ?? 0,"timingMinute":Int(minute) ?? 0]
                jsonDic["timingInterval"] = [timeDic]
                break
            }
            break
        case 3:
            switch index_path.row {
            case 0:
                let timeDic_01:Dictionary<String,Any> = ["timingHour":Int(hour) ?? 0,"timingMinute":Int(minute) ?? 0]
                let timeDic_02:Dictionary<String,Any> = ["timingHour":Int(self.timeReportModel.timingReport[1].timingHour),"timingMinute":Int(self.timeReportModel.timingReport[1].timingMinute)]
                let timeDic_03:Dictionary<String,Any> = ["timingHour":Int(self.timeReportModel.timingReport[2].timingHour),"timingMinute":Int(self.timeReportModel.timingReport[2].timingMinute)]
                jsonDic["timingInterval"] = [timeDic_01,timeDic_02,timeDic_03]
                break
            case 1:
                let timeDic_01:Dictionary<String,Any> = ["timingHour":Int(self.timeReportModel.timingReport[0].timingHour) ,"timingMinute":Int(self.timeReportModel.timingReport[0].timingMinute)]
                let timeDic_02:Dictionary<String,Any> = ["timingHour":Int(hour) ?? 0 ,"timingMinute":Int(minute) ?? 0]
                let timeDic_03:Dictionary<String,Any> = ["timingHour":Int(self.timeReportModel.timingReport[2].timingHour),"timingMinute":Int(self.timeReportModel.timingReport[2].timingMinute)]
                jsonDic["timingInterval"] = [timeDic_01,timeDic_02,timeDic_03]
                break
            case 2:
                let timeDic_01:Dictionary<String,Any> = ["timingHour":Int(self.timeReportModel.timingReport[0].timingHour),"timingMinute":Int(self.timeReportModel.timingReport[0].timingMinute)]
                let timeDic_02:Dictionary<String,Any> = ["timingHour":Int(self.timeReportModel.timingReport[1].timingHour),"timingMinute":Int(self.timeReportModel.timingReport[1].timingMinute)]
                let timeDic_03:Dictionary<String,Any> = ["timingHour":Int(hour) ?? 0,"timingMinute":Int(minute) ?? 0]
                jsonDic["timingInterval"] = [timeDic_01,timeDic_02,timeDic_03]
                break
            default:
                let timeDic:Dictionary<String,Any> = ["timingHour":Int(hour) ?? 0,"timingMinute":Int(minute) ?? 0]
                jsonDic["timingInterval"] = [timeDic]
                break
            }
            break
        default:
            let timeDic:Dictionary<String,Any> = ["timingHour":Int(hour) ?? 0,"timingMinute":Int(minute) ?? 0]
            jsonDic["timingInterval"] = [timeDic]
            break
        }
        
        paramtersBody["body"] = CBPetUtils.getJSONStringFromDictionary(dictionary: jsonDic as NSDictionary)

        paramters["body"] = CBPetUtils.getJSONStringFromDictionary(dictionary: paramtersBody as NSDictionary)
        
        MBProgressHUD.showAdded(to: CBPetUtils.getWindow(), animated: true)
        CBPetNetworkingManager.share.commandRequest(paramters: paramters , successBlock: { [weak self] (successModel) in
            guard let self = self else {return}
            MBProgressHUD.hide(for: CBPetUtils.getWindow(), animated: true)
            self.getTimeReportList()
             //返回错误信息
             guard successModel.status == "0" else {
                if successModel.rescode == "0024" {
                    MBProgressHUD.showMessage(Msg: "设备已离线".localizedStr, Deleay: 1.5)
                }  else if successModel.rescode == "0029" {
                    MBProgressHUD.showMessage(Msg: "下发指令超时".localizedStr, Deleay: 1.5)
                }
                 return;
             }
         }) { (failureModel) in
             MBProgressHUD.hide(for: CBPetUtils.getWindow(), animated: true)
         }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
