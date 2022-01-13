//
//  CBPetPsnalCterEditPetInfoVC.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/20.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

class CBPetPsnalCterEditPetInfoVC: CBPetBaseViewController,UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    public lazy var psnalCterViewModel:CBPetPsnalCterViewModel = {
        let viewModel = CBPetPsnalCterViewModel()
        return viewModel
    }()
    private lazy var petInfoView:CBPetPsnalPetInfoView = {
        let vv = CBPetPsnalPetInfoView.init()
        return vv
    }()
    private var petInfoModelObject:CBPetPsnalCterPetPet?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getPetInfoRequest()
        getQNFileTokenRequestMethod()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupView()
        //getQNFileTokenRequestMethod()
    }
    private func setupView() {
        initBarWith(title: "宠物资料".localizedStr, isBack: true)
        self.petInfoView.backgroundColor = UIColor.white
        self.view.addSubview(self.petInfoView)
        self.petInfoView.snp_makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(0)
        }
        self.petInfoView.setupViewModel(viewModel: self.psnalCterViewModel)
        self.psnalCterViewModel.pushBlock = { [weak self] (objc:Any) in
            self?.toEditePetInfoClick(objc: objc)
        }
    }
    private func toEditePetInfoClick(objc:Any) {
        if objc is CBPetPsnalCterPetPet {
            let model = (objc as! CBPetPsnalCterPetPet)
            if model.title == "头像".localizedStr {
                self.seletImagePath()
            } else if model.title == "性别".localizedStr {
                self.seletSex()
            } else if model.title == "防疫记录".localizedStr {
                if self.petInfoModelObject?.id != nil {
                    CBPetEpidemicRcdPopView.share.petInfoModelObject = self.petInfoModelObject
                } else {
                    var modelFirst = CBPetPsnalCterPetPet.init()
                    modelFirst.title = model.title
                    modelFirst.id = self.psnalCterViewModel.petInfoModel?.petId
                    CBPetEpidemicRcdPopView.share.petInfoModelObject = modelFirst
                }
                //CBPetEpidemicRcdPopView.share.petInfoModelObject = self.petInfoModelObject
                CBPetEpidemicRcdPopView.share.showAlert(token:self.viewModel.qnyToken ?? "",completeBtnBlock: { [weak self] () -> Void in
                    self?.getPetInfoRequest()
                }, cancelBtnBlock: {
                })
            } else {  /* "昵称" "品种" "宠龄"*/
                let vc = CBPetPsnalCterInputEditInfoVC.init()
                if model.id != nil {
                    vc.petInfoModel = model
                } else {
                    var modelFirst = CBPetPsnalCterPetPet.init()
                    modelFirst.title = model.title
                    modelFirst.id = self.psnalCterViewModel.petInfoModel?.petId
                    vc.petInfoModel = modelFirst
                }
                //vc.petInfoModel = model
                vc.isEditPetInfo = true
                vc.editReturnBlock = { [weak self] in
                    self?.getPetInfoRequest()
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else if objc is String {
            if objc as! String == "解除设备".localizedStr {
                CBPetPopView.share.showAlert(title: "", subTitle: "温馨提醒！您将解除该APP上的关联设备同时设备相对应的宠物资料也一并删除".localizedStr, comfirmBtnText: "解除".localizedStr, cancelBtnText: "暂不解除".localizedStr, comfirmColor: KPetAppColor, cancelColor: KPet999999Color, completeBtnBlock: { [weak self] () -> Void in
                    self!.unBindDeviceRqeust()
                }, cancelBtnBlock: { () -> Void in
                    CBLog(message: "暂不解除")
                })
            }
        }
    }
    //MARK: - 根据IMEI获取宠物信息
    private func getPetInfoRequest() {
        var paramters:Dictionary<String,Any> = Dictionary()
        paramters["imei"] = self.psnalCterViewModel.petInfoModel?.imei
        MBProgressHUD.showAdded(to: self.view, animated: true)
        CBPetNetworkingManager.share.getPetInfoByIMEIRequest(paramters:paramters,successBlock: { [weak self] (successModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
            ///返回错误信息
            guard successModel.status == "0" else {
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 1.5)
                return;
            }
            let ddJson = JSON.init(successModel.data as Any)
            self?.petInfoModelObject = CBPetPsnalCterPetPet.deserialize(from: ddJson.dictionaryObject)
            self?.petInfoView.updatePetsInfoData(petInfoModel: self?.petInfoModelObject ?? CBPetPsnalCterPetPet())
        }) { [weak self] (failureModel) in
            MBProgressHUD.hide(for: (self?.view)!, animated: true)
        }
    }
    private func seletImagePath() {
        let alertVC = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
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
            //let imageUrl = HOST + PORT + "/" + key
            let imageUrl = "http://cdn.clw.gpstrackerxy.com/" + key
            
            var paramters:Dictionary<String,Any> = ["photo":imageUrl,"id":"","userId":""]
            if let value = self?.psnalCterViewModel.petInfoModel?.petId {
                /*  该设备第一次被绑定，完善资料取 petId*/
                paramters.updateValue(value.valueStr, forKey: "id")
            } else if let value = self?.petInfoModelObject?.id {
                /* 否则取宠物信息里的 宠物Id*/
                paramters.updateValue(value.valueStr, forKey: "id")
            }
            if let value = CBPetLoginModelTool.getUser()?.uid {
                paramters.updateValue(value.valueStr, forKey: "userId")
            }
    
            self?.updatePetsInfoReuqest(paramters: paramters, key: "photo", markIndex: 2020)
        }) { (failureDic:Dictionary) in
            MBProgressHUD.showMessage(Msg: "上传头像失败".localizedStr, Deleay: 1.5)
        }
    }
    private func seletSex() {
        var markIndex = 0
        switch self.petInfoModelObject?.sex {
        case "0":
            markIndex = 0
            break
        case "1":
            markIndex = 1
            break
        case "2":
            markIndex = 2
            break
        case "3":
            markIndex = 3
            break
        default:
            break
        }
        CBPetPopSheetView.share.selectIndex = markIndex
        CBPetPopSheetView.share.isAllowSelect = true
        CBPetPopSheetView.share.showAlert(dataSource: ["MM","GG","绝育 MM".localizedStr,"绝育 GG".localizedStr], completeBtnBlock: { [weak self] (title:String, index:Int) in
            markIndex = index
            let userInfo = CBPetLoginModelTool.getUser()
            var paramters:Dictionary<String,Any> = Dictionary()
            paramters["sex"] = "\(markIndex)"
            paramters["userId"] = userInfo?.uid ?? ""
            if let value = self?.psnalCterViewModel.petInfoModel?.petId {
                /*  该设备第一次被绑定，完善资料取 petId*/
                paramters["id"] = value
            } else if let value = self?.petInfoModelObject?.id {
                /* 否则取宠物信息里的 宠物Id*/
                paramters["id"] = value
            }
            self!.updatePetsInfoReuqest(paramters: paramters,key: "sex", markIndex: markIndex)
        })
    }
    //MARK: - 修改宠物信息
    private func updatePetsInfoReuqest(paramters:Dictionary<String,Any>,key:String,markIndex:Int) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        CBPetNetworkingManager.share.updatePetsInfoRequest(paramters: paramters, successBlock: { [weak self] (successModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
            ///返回错误信息
            guard successModel.status == "0" else {
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 1.5)
                return;
            }
            guard markIndex == 2020 else {
                ///性别
                CBPetPopSheetView.share.selectIndex = markIndex
                self?.getPetInfoRequest()
                return
            }
            MBProgressHUD.showMessage(Msg: "上传头像成功", Deleay: 1.5)
            self?.getPetInfoRequest()
        }) { [weak self] (failureModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
        }
    }
    //MARK: - 解绑
    private func unBindDeviceRqeust() {
        var paramters:Dictionary<String,Any> = ["imei":"","userId":""]
        if let value = self.petInfoModelObject?.device.imei {
            paramters.updateValue(value.valueStr, forKey: "imei")
        }
        if let value = CBPetLoginModelTool.getUser()?.uid {
            paramters.updateValue(value.valueStr, forKey: "userId")
        }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        CBPetNetworkingManager.share.unbindDeviceRequest(paramters: paramters, successBlock: { [weak self] (successModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
            ///返回错误信息
            guard successModel.status == "0" else {
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 2.0)
                return;
            }
            MBProgressHUD.showMessage(Msg: "解绑成功".localizedStr, Deleay: 2.0)
            guard self!.psnalCterViewModel.psnalCterEditPetInfoUpdUIBlock == nil else {
                self?.psnalCterViewModel.psnalCterEditPetInfoUpdUIBlock!("")
                return
            }
            self?.navigationController?.popToRootViewController(animated: true)
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
