//
//  CBPetSwitchSystemVC.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/7/13.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit
import HandyJSON

struct CBPetSwitchSystemModel:HandyJSON,Codable {
    var iconImage:String?
    var title:String?
    var status:Bool = false
}
struct CBPetSwitchSystemTool {
    //MARK: - 归档路径
    static private var path:String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        return (path as NSString).appendingPathComponent("CBPetSwitchSystemModel.plist")
    }
    //MARK: - 存档
    static func saveSwitchModel(switchModel:CBPetSwitchSystemModel) {
        let encodeer = JSONEncoder()
        if let data = try? encodeer.encode(switchModel) {
            //UserDefaults.standard.set(data, forKey: path)
            NSKeyedArchiver.archiveRootObject(data, toFile: path)
            let isSuccess = NSKeyedArchiver.archiveRootObject(data, toFile: path)
            if isSuccess {
                CBLog(message: "切换系统存档成功")
            } else {
                CBLog(message: "切换系统存档失败")
            }
        }
    }
    //MARK: - 获取切换模型
    static func getSwitchModel() -> CBPetSwitchSystemModel {
        let switchModelData = NSKeyedUnarchiver.unarchiveObject(withFile: path)
        let decoder = JSONDecoder()
        if let data = switchModelData as? Data {
            let switchModel = try? decoder.decode(CBPetSwitchSystemModel.self, from: data)
            return switchModel!
        }
        return CBPetSwitchSystemModel()
    }
    //MARK: - 删除切换模型档
    static func removeSwitchModel() {
        if FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.removeItem(atPath: path)
                CBLog(message: "首页信息删档成功")
            } catch {
                CBLog(message: "首页信息删档失败")
            }
        } else {
            CBLog(message: "没有文档路径,首页信息删除失败")
        }
    }
}
class CBPetSwitchSystemVC: CBPetBaseViewController {

    private lazy var switchViewModel:CBPetSwitchSystemViewModel = {
        let viewModel = CBPetSwitchSystemViewModel()
        return viewModel
    }()
    private lazy var switchView:CBPetSwitchSystemView = {
        let view = CBPetSwitchSystemView.init()
        return view
    }()
    var isSwitchSystem:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupView()
    }
    private func setupView() {
        self.view.backgroundColor = UIColor.white
        if self.isSwitchSystem == true {
            //initBarWith(title: "选择系统".localizedStr, isBack: true)
            initBarWith(title: "系统切换".localizedStr, isBack: true)
        } else {
            initBarWith(title: "选择系统".localizedStr, isBack: false)
        }
        
        self.view.addSubview(self.switchView)
        self.switchView.snp_makeConstraints { (make) in
            make.edges.equalTo(0);
        }
        self.switchView.setupViewModel(viewModel: self.switchViewModel)
        self.switchView.clickBlock = { () -> Void in
            self.navigationController?.popToRootViewController(animated: true)
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
