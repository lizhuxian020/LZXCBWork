//
//  CBPetPsnalCterEditUserInfoVC.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/20.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

class CBPetPsnalCterEditUserInfoVC: CBPetBaseViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    private lazy var psnalCterViewModel:CBPetPsnalCterViewModel = {
        let viewModel = CBPetPsnalCterViewModel()
        return viewModel
    }()
    private lazy var psnalInfoView:CBPetPsnalInfoView = {
        let view = CBPetPsnalInfoView.init()
        return view
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupView()
        getQNFileTokenRequestMethod()
    }
    private func setupView() {
        self.view.backgroundColor = UIColor.white
        initBarWith(title: "个人信息".localizedStr, isBack: true)
        self.view.addSubview(self.psnalInfoView)
        self.psnalInfoView.snp_makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        self.psnalInfoView.setupViewModel(viewModel: self.psnalCterViewModel)
        self.psnalCterViewModel.pushBlock = { [weak self] (objc:Any) in
            self?.logoutction()
        }
        self.psnalCterViewModel.psnalCterInputEditInfoBlock = { [weak self] (model:CBPetUserInfoModel) -> Void in
            self?.editPsnalInfoAction(model: model)
        }
    }
    private func editPsnalInfoAction(model:CBPetUserInfoModel) {
        if model.title == "名字".localizedStr {
            let vc = CBPetPsnalCterInputEditInfoVC.init()
            vc.psnalCterViewModel.psnalInfoModel = model
            vc.isEditPetInfo = false
            vc.editReturnBlock = { [weak self] in
                self?.psnalInfoView.updateUserInfoData()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        } else if model.title == "头像".localizedStr {
            self.seletImagePath()
        } else if model.title == "性别".localizedStr {
            self.seletSex()
        } else {
//            case "电话".:"微信".:"邮箱".:"WhatsApp".:
            let vc = CBPetPsnalCterEditContactVC.init()
            vc.psnalCterViewModel.psnalInfoModel = model
            vc.editReturnBlock = { [weak self] in
                self?.psnalInfoView.updateUserInfoData()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    private func seletImagePath() {
        let alertVC = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)//UIAlertController(title: nil.localizedStr, message: nil, preferredStyle: .actionSheet)
        alertVC.addAction(UIAlertAction.init(title: "从相册选择".localizedStr, style: .default, handler: { (action:UIAlertAction) in
            let pickerImage = UIImagePickerController.init()
            pickerImage.sourceType = .photoLibrary
            pickerImage.allowsEditing = true
            pickerImage.delegate = self
            self.present(pickerImage, animated: true, completion: nil)
        }))
        alertVC.addAction(UIAlertAction.init(title: "拍照".localizedStr, style: .default, handler: { (action:UIAlertAction) in
            let pickerImage = UIImagePickerController.init()
            pickerImage.sourceType = .camera
            pickerImage.allowsEditing = true
            pickerImage.delegate = self
            self.present(pickerImage, animated: true, completion: nil)
        }))
        alertVC.addAction(UIAlertAction.init(title: "取消".localizedStr, style: .default, handler: { (action:UIAlertAction) in
        }))
        self.present(alertVC, animated: true, completion: nil)
    }
    //MARK: - UINavigationControllerDelegate, UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let newPhoto:UIImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as! UIImage
        let uploadImage = newPhoto.reSize(newSize: CGSize(width: 83, height: 83))
        self.dismiss(animated: true, completion: { [weak self] in
            ///上传图片
            self?.uploadImageToQN(image: uploadImage)
        })
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    private func uploadImageToQN(image:UIImage) {
        if self.viewModel.qnyToken == nil {
            self.getQNFileTokenRequestMethod()
            return
        }
        CBPetNetworkingManager.share.uploadImageToQNFileRequest(imageFilePath: image, token: self.viewModel.qnyToken ?? "", successBlock: { [weak self] (successDic:Dictionary) in
            let key = successDic["key"] as! String
            //let hash = successDic["hash"]
            //let imageUrl = HOST + PORT + "/" + key
            let imageUrl = "http://cdn.clw.gpstrackerxy.com/" + key
            var paramters:Dictionary<String,Any> = ["photo":imageUrl,"id":""]
            if let value = CBPetLoginModelTool.getUser()?.uid {
                paramters.updateValue(NSNumber.init(value: Int(value.valueStr) ?? 0), forKey: "id")
            }
            self?.updateUserInfoReuqest(paramters: paramters, key: "photo", markIndex: 2020)
        }) { (failureDic:Dictionary) in
            MBProgressHUD.showMessage(Msg: "上传头像失败".localizedStr, Deleay: 1.5)
        }
    }
    private func seletSex() {
        let userInfo = CBPetUserInfoModelTool.getUserInfo()
        var markIndex = 0
        if userInfo.sex == "0" {
            markIndex = 0
        } else if userInfo.sex == "1" {
            markIndex = 1
        }
        CBPetPopSheetView.share.selectIndex = markIndex
        CBPetPopSheetView.share.isAllowSelect = true
        CBPetPopSheetView.share.showAlert(dataSource: ["男".localizedStr,"女".localizedStr], completeBtnBlock: { [weak self] (title:String, index:Int) in
            markIndex = index
            //CBPetPopSheetView.share.selectIndex = markIndex
            let uid:Int = Int(CBPetLoginModelTool.getUser()!.uid!)!
            let paramters:Dictionary<String,Any> = ["sex":"\(markIndex)","id":NSNumber.init(value: uid)]
            self!.updateUserInfoReuqest(paramters: paramters,key: "sex", markIndex: markIndex)
        })
    }
    //MARK: - 修改用户信息
    private func updateUserInfoReuqest(paramters:Dictionary<String,Any>,key:String,markIndex:Int) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        CBPetNetworkingManager.share.updateUserInfoRequest(paramters: paramters, successBlock: { [weak self] (successModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
            ///返回错误信息
            guard successModel.status == "0" else {
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 1.5)
                return;
            }
            var userInfo = CBPetUserInfoModelTool.getUserInfo()
            guard markIndex == 2020 else {
                ///性别
                CBPetPopSheetView.share.selectIndex = markIndex
                userInfo.sex = (paramters[key] as! String)
                CBPetUserInfoModelTool.saveUserInfo(userInfoModel: userInfo)
                self?.psnalInfoView.updateUserInfoData()
                return
            }
            userInfo.photo = (paramters[key] as! String)
            CBPetUserInfoModelTool.saveUserInfo(userInfoModel: userInfo)
            MBProgressHUD.showMessage(Msg: "上传头像成功".localizedStr, Deleay: 1.5)
            self?.psnalInfoView.updateUserInfoData()
            
        }) { [weak self] (failureModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
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
