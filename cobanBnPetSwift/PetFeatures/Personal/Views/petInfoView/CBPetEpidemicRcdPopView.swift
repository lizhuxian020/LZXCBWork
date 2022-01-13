//
//  CBPetEpidemicRcdPopView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/22.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetEpidemicRcdPopView: CBPetBaseView,UITextViewDelegate,UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    /// 点击完成按钮的回调
    private var clickComfirmBtnBlock:(() -> Void)?
    /// 点击取消的回调
    private var clickCancelBtnBlock:(() -> Void)?
    
    private static var _sharedInstance:CBPetEpidemicRcdPopView?
    ///单例
    static let share:CBPetEpidemicRcdPopView = {
        _sharedInstance = CBPetEpidemicRcdPopView.init()
        return _sharedInstance!
    }()
    ///背景view
    private lazy var bgView:CBPetBaseView = {
        let bgmV = CBPetBaseView()
        bgmV.layer.cornerRadius = 16*KFitHeightRate
        bgmV.layer.masksToBounds = true
        bgmV.backgroundColor = UIColor.white
        return bgmV
    }()
    ///背景view
    private lazy var inputBgView:CBPetBaseView = {
        let bgmV = CBPetBaseView()
        bgmV.layer.cornerRadius = 16*KFitHeightRate
        bgmV.layer.masksToBounds = true
        bgmV.backgroundColor = KPetBgmColor
        return bgmV
    }()
    private lazy var addPhotoBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton(imageName: "pet_petInfo_addPhoto")
        return  btn
    }()
    private lazy var photoImageView:UIImageView = {
        let imgV = UIImageView()
        imgV.isUserInteractionEnabled = true
        imgV.layer.cornerRadius = 4*KFitHeightRate
        imgV.layer.masksToBounds = true
        return  imgV
    }()
    ///标题
    private lazy var titleLb:UILabel = {
        let lb = UILabel(text: "上传相关防疫照片".localizedStr, textColor: KPet999999Color, font: UIFont(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!, textAlignment: .left)
        return lb
    }()
    ///输入UIIextView
    private lazy var inputTextView:UITextView = {
        let tv = UITextView()
        tv.delegate = self
        tv.text = "请输入30个文字以内的防疫记录".localizedStr
        tv.textColor = KPet666666Color
        tv.isScrollEnabled = true//可以滚动
        //tv.autoresizingMask = .flexibleHeight//自适应高度
        tv.layer.cornerRadius = 8*KFitHeightRate
        return tv
    }()
    private lazy var line_horizonl:UIView = {
        let line = CBPetUtilsCreate.createLineView()
        line.backgroundColor = KPetLineColor
        return line
    }()
    private lazy var line_vertical:UIView = {
        let line = CBPetUtilsCreate.createLineView()
        line.backgroundColor = KPetLineColor
        return line
    }()
    /// 取消按钮
    private lazy var cancelBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton(title: "取消".localizedStr, titleColor: KPet999999Color, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!)
        btn.addTarget(self, action: #selector(clickCancelBtn), for: UIControl.Event.touchUpInside)
        return  btn
    }()
    /// 完成按钮
    private lazy var comfirmBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton(title: "确定".localizedStr, titleColor: KPetAppColor, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!)
        btn.addTarget(self, action: #selector(clickComfirmBtn), for: UIControl.Event.touchUpInside)
        return  btn
    }()
    public var qnyToken:String?
    public var petInfoModelObject:CBPetPsnalCterPetPet?
    var paramters:Dictionary<String,Any>? = Dictionary()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupBgmView()
        registerNotification()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        /// 防止y超过屏幕
        if self.bgView.frame.size.height >= (SCREEN_HEIGHT - NavigationBarHeigt - TabBARHEIGHT - TabPaddingBARHEIGHT) {
            self.bgView.snp_remakeConstraints { (make) in
                make.center.equalTo(self)
                make.width.equalTo(SCREEN_WIDTH-106*KFitWidthRate)
                make.height.equalTo((SCREEN_HEIGHT - NavigationBarHeigt - TabBARHEIGHT - TabPaddingBARHEIGHT))
            }
        }
    }
    //MARK: - 弹出视图
    /// 无标题显示弹框,前提初始化时候带标题
    public func showAlert(token:String,completeBtnBlock:@escaping() -> Void,cancelBtnBlock:@escaping() -> Void) {
        UIApplication.shared.keyWindow!.subviews.forEach { (vv) in
           if vv is CBPetEpidemicRcdPopView {
               return
           }
        }
        self.qnyToken = token
        //UIApplication.shared.keyWindow!.addSubview(self)
        UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(self)
        self.clickComfirmBtnBlock = completeBtnBlock
        self.clickCancelBtnBlock = cancelBtnBlock
        self.alpha = 0
        self.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3) {
           self.alpha = 1
           self.isUserInteractionEnabled = true
        }
        self.photoImageView.image = UIImage(named: "pet_petInfo_addPhoto")!
        //self.inputTextView.text = "请输入30个文字以内的防疫记录".localizedStr
    }
   
    //MARK: - 设置view
    private func setupBgmView() {
        self.backgroundColor = UIColor.init().colorWithHexString(hexString: "#222222", alpha: 0.85)
        self.frame = UIScreen.main.bounds
        /// 马上刷新界面  ///self.layoutIfNeeded()        ///强制刷新布局 ///setNeedsLayout
        self.addSubview(self.bgView)
        self.bgView.snp_makeConstraints { (make) in
            make.center.equalTo(self)
            make.width.equalTo(SCREEN_WIDTH-106*KFitWidthRate)
        }
        setupAlertView()
    }
    private func setupAlertView() {
        self.bgView.addSubview(self.inputBgView)
        self.inputBgView.snp_makeConstraints { (make) in
            make.top.equalTo(self.bgView.snp_top).offset(25*KFitHeightRate)
            make.left.equalTo(self.bgView.snp_left).offset(20*KFitWidthRate)
            make.right.equalTo(self.bgView.snp_right).offset(-20*KFitWidthRate)
        }
//        self.inputTextView.becomeFirstResponder()
//        self.inputTextView.selectedTextRange = self.inputTextView.textRange(from: self.inputTextView.beginningOfDocument, to: self.inputTextView.beginningOfDocument)
        self.inputBgView.addSubview(self.inputTextView)
        self.inputTextView.snp_makeConstraints { (make) in
            make.top.equalTo(self.inputBgView.snp_top).offset(15*KFitHeightRate)
            make.left.equalTo(self.inputBgView.snp_left).offset(15*KFitWidthRate)
            make.right.equalTo(self.inputBgView.snp_right).offset(-15*KFitWidthRate)
            make.height.equalTo(60*KFitHeightRate)
        }
        
        let petImage = UIImage(named: "pet_petInfo_addPhoto")!
        self.inputBgView.addSubview(self.photoImageView)
        self.photoImageView.snp_makeConstraints { (make) in
            make.left.equalTo(self.inputBgView.snp_left).offset(15*KFitWidthRate)
            make.top.equalTo(self.inputTextView.snp_bottom).offset(15*KFitHeightRate)
            make.bottom.equalTo(self.inputBgView.snp_bottom).offset(-15*KFitHeightRate)
            make.size.equalTo(CGSize(width: petImage.size.width, height: petImage.size.height))
        }
        
        self.inputBgView.addSubview(self.addPhotoBtn)
        self.addPhotoBtn.snp_makeConstraints { (make) in
            make.left.equalTo(self.inputBgView.snp_left).offset(15*KFitWidthRate)
            make.top.equalTo(self.inputTextView.snp_bottom).offset(15*KFitHeightRate)
            make.bottom.equalTo(self.inputBgView.snp_bottom).offset(-15*KFitHeightRate)
            make.size.equalTo(CGSize(width: petImage.size.width, height: petImage.size.height))
        }
        self.addPhotoBtn.addTarget(self, action: #selector(seletImagePath), for: .touchUpInside)
        
        self.inputBgView.addSubview(self.titleLb)
        self.titleLb.snp_makeConstraints { (make) in
            make.left.equalTo(self.addPhotoBtn.snp_right).offset(23*KFitWidthRate)
            make.bottom.equalTo(self.addPhotoBtn.snp_bottom).offset(0)
        }
        
        self.bgView.addSubview(self.line_horizonl)
        self.line_horizonl.snp_makeConstraints { (make) in
            make.top.equalTo(self.inputBgView.snp_bottom).offset(22*KFitHeightRate)
            make.left.equalTo(self.bgView.snp_left).offset(0)
            make.right.equalTo(self.bgView.snp_right).offset(0)
            make.height.equalTo(0.8*KFitHeightRate)
        }
        self.bgView.addSubview(self.line_vertical)
        self.line_vertical.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.bgView)
            make.top.equalTo(self.line_horizonl.snp_bottom).offset(0)
            make.size.equalTo(CGSize(width: 0.8*KFitWidthRate, height: 44*KFitHeightRate))
            make.bottom.equalTo(self.bgView.snp_bottom).offset(0)
        }
        self.bgView.addSubview(self.cancelBtn)
        self.bgView.addSubview(self.comfirmBtn)
        self.cancelBtn.snp_makeConstraints { (make) in
            make.top.equalTo(self.line_vertical.snp_top)
            make.left.equalTo(self.bgView.snp_left).offset(0)
            make.right.equalTo(self.snp_centerX).offset(0)
            make.bottom.equalTo(self.bgView.snp_bottom).offset(0)
        }
        self.comfirmBtn.snp_makeConstraints { (make) in
            make.top.equalTo(self.line_vertical.snp_top)
            make.left.equalTo(self.snp_centerX).offset(0)
            make.right.equalTo(self.bgView.snp_right).offset(0)
            make.bottom.equalTo(self.bgView.snp_bottom).offset(0)
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == KPet666666Color {
            textView.text = nil
            textView.textColor = KPetTextColor
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "请输入30个文字以内的防疫记录".localizedStr
            textView.textColor = KPet666666Color
        }
    }
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        //将textView文本和替换文本合并到
//         //创建更新后的文本字符串
//        let currentText:String = textView.text
//        let updatedText = (currentText as NSString).replacingCharacters(in:range,with:text)
//         //如果更新后的文本视图为空，则添加占位符
//         //并将光标设置为文本视图的开始
//        if updatedText.isEmpty {
//            textView.text = "请输入30个文字以内的防疫记录".localizedStr
//            textView.textColor = KPet666666Color
//            textView.selectedTextRange = self.inputTextView.textRange(from: self.inputTextView.beginningOfDocument, to: self.inputTextView.beginningOfDocument)
//        } else if textView.textColor == KPet666666Color && text.isEmpty == false {
//            textView.text = text
//            textView.textColor = KPetTextColor
//        } else {
//            return true
//        }
//        return false
//    }
    //MARK: - 移除弹框(内部移除)
    /// 移除弹框(内部移除)
    private func removeView() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.alpha = 0
        }) { [weak self] (res) in
            /// 关闭时恢复约束
            self?.bgView.snp_remakeConstraints { (make) in
                make.center.equalTo(self!)
                make.width.equalTo(SCREEN_WIDTH-106*KFitWidthRate)
            }
            self?.removeFromSuperview()
            CBPetEpidemicRcdPopView._sharedInstance = nil
        }
    }
    @objc private func seletImagePath() {
        let alertVC = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)//UIAlertController(title: nil.localizedStr, message: nil, preferredStyle: .actionSheet)
        alertVC.addAction(UIAlertAction.init(title: "从相册选择".localizedStr, style: .default, handler: { (action:UIAlertAction) in
            let pickerImage = UIImagePickerController.init()
            pickerImage.sourceType = .photoLibrary
            pickerImage.allowsEditing = true
            pickerImage.delegate = self
            UIViewController.getCurrentVC()?.present(pickerImage, animated: true, completion: nil)
        }))
        alertVC.addAction(UIAlertAction.init(title: "拍照".localizedStr, style: .default, handler: { (action:UIAlertAction) in
            let pickerImage = UIImagePickerController.init()
            pickerImage.sourceType = .camera
            pickerImage.allowsEditing = true
            pickerImage.delegate = self
            UIViewController.getCurrentVC()?.present(pickerImage, animated: true, completion: nil)
        }))
        alertVC.addAction(UIAlertAction.init(title: "取消".localizedStr, style: .default, handler: { (action:UIAlertAction) in
        }))
        UIViewController.getCurrentVC()?.present(alertVC, animated: true, completion: nil)
    }
    //MARK: - UINavigationControllerDelegate, UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let newPhoto:UIImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as! UIImage
        let uploadImage = newPhoto//newPhoto.reSize(newSize: CGSize(width: 83, height: 83))
        UIViewController.getCurrentVC()?.dismiss(animated: true, completion: { [weak self] in
            ///上传图片
            self?.uploadImageToQN(image: uploadImage)
        })
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    private func uploadImageToQN(image:UIImage) {
        
        CBPetNetworkingManager.share.uploadImageToQNFileRequest(imageFilePath: image, token: self.qnyToken ?? "", successBlock: { [weak self] (successDic:Dictionary) in
            let key = successDic["key"] as! String
            //let hash = successDic["hash"]
            //let imageUrl = HOST + PORT + "/" + key
            let imageUrl = "http://cdn.clw.gpstrackerxy.com/" + key
            self?.paramters?["epidemicImage"] = imageUrl
            self?.photoImageView.sd_setImage(with: URL.init(string: imageUrl), placeholderImage: UIImage(named: "pet_petInfo_addPhoto"), options: [])
            self?.addPhotoBtn.setImage(nil, for: .normal)
            self?.addPhotoBtn.setImage(nil, for: .highlighted)
        }) { (failureDic:Dictionary) in
            MBProgressHUD.showMessage(Msg: "上传头像失败".localizedStr, Deleay: 1.5)
        }
    }
    //MARK: - 修改宠物信息
    private func updatePetsInfoReuqest(paramters:Dictionary<String,Any>) {
        MBProgressHUD.showAdded(to: self.bgView, animated: true)
        CBPetNetworkingManager.share.updatePetsInfoRequest(paramters: paramters, successBlock: { [weak self] (successModel) in
            MBProgressHUD.hide(for: self!.bgView, animated: true)
            ///返回错误信息
            guard successModel.status == "0" else {
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 1.5)
                return;
            }
            //MBProgressHUD.showMessage(Msg: "上传头像成功", Deleay: 1.5)
            self?.clickComfirmBtnBlock?()
            self?.removeView()
            
        }) { [weak self] (failureModel) in
            MBProgressHUD.hide(for: self!.bgView, animated: true)
        }
    }
    //MARK:监听键盘通知
    func registerNotification() {
        // 监听键盘弹出通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name:UIResponder.keyboardWillShowNotification,object: nil)
        // 监听键盘隐藏通知
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillHide(notification:)),name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    // 键盘显示
    @objc func keyboardWillShow(notification: Notification) {
        CBLog(message: "键盘将要出现")
        DispatchQueue.main.async {
            ///
            let userInfo = notification.userInfo
            let keyboardRect = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            UIView.animate(withDuration: 0.25, animations: {
                self.bgView.snp_remakeConstraints { (make) in
                    make.centerX.equalTo(self)
                    make.width.equalTo(SCREEN_WIDTH-106*KFitWidthRate)
                    make.bottom.equalTo(-keyboardRect.origin.y)
                }
            })
        }
    }
    // 键盘隐藏
    @objc func keyboardWillHide(notification: Notification) {
        CBLog(message: "键盘将要隐藏")
        UIView.animate(withDuration: 0.25, animations: {
            self.bgView.snp_remakeConstraints { (make) in
                make.center.equalTo(self)
                make.width.equalTo(SCREEN_WIDTH-106*KFitWidthRate)
            }
        })
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "" {
            return true
        }
        /* 限制最大输入字数为30*/
        if range.location >= 30 {
            return false
        } else {
            return true
        }
    }
    // 移除通知
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
extension CBPetEpidemicRcdPopView {
    @objc private func clickComfirmBtn() {
        if self.inputTextView.text.isEmpty == true || self.inputTextView.text == "".localizedStr {
            MBProgressHUD.showMessage(Msg: "请输入30个文字以内的防疫记录".localizedStr, Deleay: 1.5)
            return
        }
        if let value = self.petInfoModelObject?.id {
            self.paramters?["id"] = value.valueStr
        }
        if let value = CBPetLoginModelTool.getUser()?.uid {
            self.paramters?["userId"] = value.valueStr
        }
        self.paramters?["epidemicRecord"] = self.inputTextView.text
        self.updatePetsInfoReuqest(paramters: self.paramters ?? Dictionary())
    }
    @objc private func clickCancelBtn() {
        clickCancelBtnBlock?()
        self.removeView()
    }
}
