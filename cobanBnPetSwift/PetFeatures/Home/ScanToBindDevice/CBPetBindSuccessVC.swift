//
//  CBPetBindSuccessVC.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/5/25.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetBindSuccessVC: CBPetBaseViewController {

    var imeiStr:String?
    var petId:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupView()
        editNaviVC()
    }
    /* 移除目标vc，pop 到需要的vc*/
    private func editNaviVC () {
        /*
        for controller in self.navigationController!.viewControllers {
            if (controller.isKind(of: CBPetScanToBindDeviceVC.self)) || (controller.isKind(of: CBPetScanInputVC.self)) {
                //若用self removeFromParentViewController这个方法，但是会出现小得问题就放弃使用了。返回后当前的导航栏没变，会是返回前的控制器的导航栏
                controller.removeFromParent()
            }
        }
        */
        
        let navMutArray = NSMutableArray.init(array:(self.navigationController?.viewControllers)!)
        for controller in navMutArray {
            if ((controller as! UIViewController) .isKind(of: CBPetScanToBindDeviceVC.self)) || ((controller as! UIViewController).isKind(of: CBPetScanInputVC.self)) {
                //用这个方法，但是会出现小得问题就放弃使用了。返回后当前的导航栏没变，会是返回前的控制器的导航栏
                //vc.removeFromParent()
                navMutArray.remove(controller)
                //break;
            }
        }
        self.navigationController?.viewControllers = navMutArray as! [UIViewController];
    }
    private func setupView() {
        self.view.backgroundColor = UIColor.white
        self.initBarWith(title: "绑定成功".localizedStr, isBack: true)
        
        let titleLb = UILabel(text: "欢迎使用宠物定位器".localizedStr, textColor: KPetTextColor, font: UIFont.init(name: CBPingFangSC_Regular, size: 18*KFitHeightRate)!, textAlignment: .center)
        self.view.addSubview(titleLb)
        titleLb.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp_centerX)
            make.width.equalTo(SCREEN_WIDTH-30*KFitWidthRate)
            make.top.equalTo(40*KFitHeightRate + CGFloat(NavigationBarHeigt))
        }
        
        let noteLb = UILabel(text: "开始体验宠物定位器神奇技能".localizedStr, textColor: KPet666666Color, font: UIFont.init(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!, textAlignment: .center)
        self.view.addSubview(noteLb)
        noteLb.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp_centerX)
            make.width.equalTo(SCREEN_WIDTH-30*KFitWidthRate)
            make.top.equalTo(titleLb.snp_bottom).offset(20*KFitHeightRate)
        }
        
        let logoImageView = UIImageView.init()
        let logoImage = UIImage.init(named: "pet_bindPetSuccessLogo")!
        logoImageView.image = logoImage
        self.view.addSubview(logoImageView)
        logoImageView.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp_centerX)
            make.top.equalTo(noteLb.snp_bottom).offset(60*KFitHeightRate)
            make.size.equalTo(CGSize(width: logoImage.size.width, height: logoImage.size.height))
        }
        
        let editPetInfoBtn = UIButton(title: "去完善宠物资料".localizedStr, titleColor: UIColor.white, font: UIFont.init(name: CBPingFangSC_Regular, size: 16*KFitHeightRate)!)
        editPetInfoBtn.setShadow(backgroundColor: KPetAppColor, cornerRadius: 20*KFitHeightRate, shadowColor: KPetAppColor, shadowOpacity: 0.35, shadowOffset: CGSize(width: 4, height: 0), shadowRadius: 8)
        self.view.addSubview(editPetInfoBtn)
        editPetInfoBtn.snp_makeConstraints { (make) in
            make.height.equalTo(40*KFitHeightRate)
            make.left.equalTo(20*KFitWidthRate)
            make.right.equalTo(-20*KFitWidthRate)
            make.top.equalTo(logoImageView.snp_bottom).offset(40*KFitHeightRate)
        }
        editPetInfoBtn.addTarget(self, action: #selector(editPetInfoClick), for: .touchUpInside)
    }
    @objc private func editPetInfoClick() {
        let editPetInfoVC = CBPetPsnalCterEditPetInfoVC.init()

        var petInfoModel = CBPetPsnalCterPetModel.init()
        petInfoModel.imei = self.imeiStr
        petInfoModel.petId = self.petId
        
        editPetInfoVC.psnalCterViewModel.petInfoModel = petInfoModel
        
        self.navigationController?.pushViewController(editPetInfoVC, animated: true)
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
