//
//  CBPetScanToBindDeviceVC.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/5/24.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftyJSON

class CBPetScanToBindDeviceVC: CBPetBaseViewController, AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    /* 输入输出的中间桥梁*/
    var session:AVCaptureSession?
    /* 输出流*/
    //var metadataOut:AVCaptureMetadataOutput?
    private lazy var metadataOut:AVCaptureMetadataOutput = {
        let meta = AVCaptureMetadataOutput.init()
        return meta
    }()
    /* 设备*/
    var device:AVCaptureDevice?
    /* 相机图层*/
    var previewLayer:AVCaptureVideoPreviewLayer?
    var deviceImageView:UIImageView?
    /* 扫描支持的编码格式的数组 */
    private var metadataObjectTypesArray:[Any] = {
        var arr = [AVMetadataObject.ObjectType.aztec,
        AVMetadataObject.ObjectType.code128,
        AVMetadataObject.ObjectType.code39,
        AVMetadataObject.ObjectType.code39Mod43,
        AVMetadataObject.ObjectType.code93,
        AVMetadataObject.ObjectType.ean13,
        AVMetadataObject.ObjectType.ean8,
        AVMetadataObject.ObjectType.pdf417,
        AVMetadataObject.ObjectType.qr,
        AVMetadataObject.ObjectType.upce,
        // >= iOS8
        AVMetadataObject.ObjectType.interleaved2of5,
        AVMetadataObject.ObjectType.itf14,
        AVMetadataObject.ObjectType.dataMatrix,];
        return arr
    }()
    var lightBtn:UIButton?
    /* 扫描线*/
    var line:UIImageView = {
        let line = UIImageView.init()
        return line
    }()
    //var scannedReusltStr:String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /* 开始捕获*/
        self.session?.startRunning()
        self.line.frame = CGRect(x: 0, y: 0, width: 235*KFitWidthRate, height: 1*KFitWidthRate);
        UIView.animate(withDuration: 2.0, delay: 0.0, options: .repeat, animations: {
            self.line.frame = CGRect(x: 0, y: 224*KFitWidthRate, width: 235*KFitWidthRate, height: 1*KFitWidthRate);
        }, completion: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        /* 停止捕获*/
        self.session?.stopRunning()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupView()
    }
    private func setupView() {
        self.view.backgroundColor = UIColor.white
        self.initBarWith(title: "扫描设备二维码".localizedStr, isBack: true)
        self.initBarRight(title: "相册".localizedStr, action: #selector(pickFromAlbum))
        self.rightBtn.titleLabel?.font = UIFont.init(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)
        self.rightBtn.setTitleColor(KPetAppColor, for: .normal)
        self.capture()
        self.addGesture()
        self.initFontView()
    }
    private func capture() {
        /* 获取摄像设备*/
        self.device = AVCaptureDevice.default(for: .video)
        if self.device == nil {
            MBProgressHUD.showMessage(Msg: "获取相机失败".localizedStr, Deleay: 2.0)
            return
        }
        do {
            /* 创建输入流*/
            let input = try AVCaptureDeviceInput.init(device: self.device!)
            /* 创建输出流*/
            self.metadataOut = AVCaptureMetadataOutput.init()
            /* 设置代理 在主线程里刷新*/
            self.metadataOut.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            /* 初始化链接对象*/
            self.session = AVCaptureSession.init()
            /* 高质量采集率*/
            self.session?.sessionPreset = .high
            if (self.session?.canAddInput(input))! {
                self.session?.addInput(input)
            }
            if (self.session?.canAddOutput(self.metadataOut))!  {
                self.session?.addOutput(self.metadataOut)
            }
            self.previewLayer = AVCaptureVideoPreviewLayer.init(session: self.session!)
            self.previewLayer?.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
            self.previewLayer?.videoGravity = .resizeAspectFill
            self.view.layer.addSublayer(self.previewLayer!)
            /* 设置扫描支持的编码格式(如下设置条形码和二维码兼容)*/
            self.metadataOut.metadataObjectTypes = (self.metadataObjectTypesArray as! [AVMetadataObject.ObjectType])
            let size1 = CGRect.init(x: 0, y: 0, width: 1, height: 1)////CGRect.init(x: ((SCREEN_HEIGHT - 235*KFitWidthRate - (SCREEN_HEIGHT - 235*KFitWidthRate)/2) / 2) / SCREEN_HEIGHT, y: ((SCREEN_WIDTH - 235*KFitWidthRate)/2)/SCREEN_WIDTH, width: (235*KFitWidthRate) / 1, height: (235*KFitWidthRate) / 1)  ///CGRect.init(x: ((SCREEN_HEIGHT - 235*KFitWidthRate - (SCREEN_HEIGHT - 235*KFitWidthRate)/2) / 2) / SCREEN_HEIGHT, y: ((SCREEN_WIDTH - 235*KFitWidthRate)/2)/SCREEN_WIDTH, width: (235*KFitWidthRate) / SCREEN_HEIGHT, height: (235*KFitWidthRate) / SCREEN_WIDTH)  /////CGRect.init(x: (50*KFitWidthRate + kNavAndStatusHeight) / SCREEN_HEIGHT, y: ((SCREEN_WIDTH - 235)/2 * KFitWidthRate) / SCREEN_WIDTH, width: (250*KFitWidthRate) / SCREEN_HEIGHT, height: (250*KFitWidthRate) / SCREEN_WIDTH)
            //self.metadataOut.rectOfInterest = size1//CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)//size1
            self.coverToMetadataOutputRectOfInterestForRect(cropRect: CGRect.init(x: (SCREEN_WIDTH-235*KFitWidthRate)/2, y: (SCREEN_HEIGHT-235*KFitWidthRate)/2, width: 235*KFitWidthRate, height: 235*KFitWidthRate))
        } catch {
            CBLog(message: "创建输入流失败:\(error)")
        }
    }
    private func addGesture() {
//        self.view.isUserInteractionEnabled = true
//        let singleTap = UITapGestureRecognizer.init(target: self, action: #selector(fingerTap))
//        self.view.addGestureRecognizer(singleTap)
    }
    @objc private func fingerTap(gestureRecognizer:UITapGestureRecognizer) {
        //self.view.endEditing(true)
    }
    private func initFontView() {
        let qrImage = UIImage.init(named: "pet_scan_frame")
        let qrImageView = UIImageView.init(image: qrImage)
        self.view.addSubview(qrImageView)
        qrImageView.snp_makeConstraints { (make) in
            //make.top.equalTo(50*KFitHeightRate + kNavAndStatusHeight)
            make.size.equalTo(CGSize(width: 235*KFitWidthRate, height: 235*KFitWidthRate))
            make.center.equalTo(self.view)
        }
        
        // 上下左右的阴影
        let backColor = UIColor.black.withAlphaComponent(0.3)
        let topView = UIView.init()
        topView.backgroundColor = backColor
        self.view.addSubview(topView)
        topView.snp_makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.equalTo(0)
            make.bottom.equalTo(qrImageView.snp_top)
        }
        let leftView = UIView.init()
        leftView.backgroundColor = backColor
        self.view.addSubview(leftView)
        leftView.snp_makeConstraints { (make) in
            make.top.equalTo(topView.snp_bottom)
            make.left.equalTo(0)
            make.bottom.equalTo(qrImageView)
            make.right.equalTo(qrImageView.snp_left)
        }
        let rightView = UIView.init()
        rightView.backgroundColor = backColor
        self.view.addSubview(rightView)
        rightView.snp_makeConstraints { (make) in
            make.top.equalTo(topView.snp_bottom)
            make.right.equalTo(0)
            make.bottom.equalTo(qrImageView)
            make.left.equalTo(qrImageView.snp_right)
        }
        let bottomView = UIView.init()
        bottomView.backgroundColor = backColor
        self.view.addSubview(bottomView)
        bottomView.snp_makeConstraints { (make) in
            make.top.equalTo(qrImageView.snp_bottom)
            make.right.left.bottom.equalTo(0)
        }
        // 扫描线
        self.line = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 235*KFitWidthRate, height: 1*KFitWidthRate))
        self.line.image = UIImage.init(named: "pet_scan_line")
        qrImageView.addSubview(self.line)
        
        let detailLb = UILabel(text: "请对准需要识别设备的二维码".localizedStr, textColor: UIColor.white, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!, textAlignment: .center)
        self.view.addSubview(detailLb)
        detailLb.snp_makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(qrImageView.snp_bottom).offset(20*KFitHeightRate)
        }
        
        let strLb = "多次扫描不成功？试试".localizedStr
        let strBtn = "输入绑定号".localizedStr
        let widthLb = strLb.getWidthText(text: strLb, font: UIFont.init(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!, height: 15*KFitHeightRate)
        let widthBtn = strBtn.getWidthText(text: strBtn, font: UIFont.init(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!, height: 15*KFitHeightRate)
        
        let bottomLb = UILabel(text: strLb, textColor: UIColor.white, font: UIFont.init(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!, textAlignment: .center)
        self.view.addSubview(bottomLb)
        
        let bottomBtn = UIButton(title: strBtn, titleColor: KPetAppColor, font: UIFont.init(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!)
        bottomBtn.underline()
        bottomBtn.addTarget(self, action: #selector(toInputBindNumber), for: .touchUpInside)
        self.view.addSubview(bottomBtn)
        
        bottomLb.snp_makeConstraints { (make) in
            make.left.equalTo((SCREEN_WIDTH - widthLb - widthBtn)/2)
            make.bottom.equalTo(-35*KFitHeightRate)
            make.width.equalTo(widthLb)
        }
        bottomBtn.snp_makeConstraints { (make) in
            make.left.equalTo(bottomLb.snp_right).offset(0)
            make.centerY.equalTo(bottomLb.snp_centerY)
            make.width.equalTo(widthBtn)
        }
    }
    //MARK: -- 从相册选取
    @objc private func pickFromAlbum() {
        CBLog(message: "从相册扫描")
        let pickerImageVC = UIImagePickerController.init()
        pickerImageVC.sourceType = .photoLibrary
        // 允许编辑，放大裁剪
        pickerImageVC.allowsEditing = true
        pickerImageVC.delegate = (self as UIImagePickerControllerDelegate & UINavigationControllerDelegate)
        self.present(pickerImageVC, animated: true, completion: nil)
    }
    //MARK: -- pickerImageVC 代理方法 相册中识别二维码
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //1、取出选中的图片
        let newPhoto = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        let ciImage = CIImage(image: newPhoto)
        //2、从选中的图片中读取二维码数据
        //2.1、创建一个探测器
        //CIDetectorTypeFace -- 人脸识别
        let detector = CIDetector.init(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])
        //2.2、利用探测器探测数据
        let results = detector?.features(in: ciImage!)
        //2.3、取出探测到的数据
        if results!.count > 0 {
            let qrFeatures = results?.first as? CIQRCodeFeature
            let scannedReuslt = qrFeatures?.messageString
            self.valudateIMEIRequest(scannedStr: scannedReuslt ?? "")
        } else {
            MBProgressHUD.showMessage(Msg: "没有识别到二维码信息".localizedStr, Deleay: 2.0)
        }
        self.dismiss(animated: true, completion: nil)
    }
    //MARK: -- 扫描代理方法
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count > 0 {
            self.session?.stopRunning()
            let metadataObject = metadataObjects.first as! AVMetadataMachineReadableCodeObject
            let result = metadataObject.stringValue
            CBLog(message: "扫描到结果:\(result!)")
            self.valudateIMEIRequest(scannedStr: result ?? "")
            //self.session?.startRunning()
        }
    }
    //MARK: -- 输入绑定号
    @objc private func toInputBindNumber () {
        let inputBindNumber = CBPetScanInputVC.init()
        self.navigationController?.pushViewController(inputBindNumber, animated: true)
    }
    //MARK: - 验证IMEI合法性
    private func valudateIMEIRequest(scannedStr:String) {
        guard scannedStr.isEmpty == false else {
            return
        }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let paramters:Dictionary<String, Any> = ["imei":scannedStr]
        CBPetNetworkingManager.share.valudateIMEIRequest(paramters: paramters, successBlock: { [weak self] (successModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
            ///返回错误信息
            guard successModel.status == "0" else {
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 2.0)
                return;
            }
            let imeiJson = JSON.init(successModel.data as Any)
            guard imeiJson.dictionaryValue.count == 0 else {
                self?.bindDeviceByValudateIMEI(imeiStr: scannedStr)
                return
            }
            MBProgressHUD.showMessage(Msg: "设备绑定号码不存在".localizedStr, Deleay: 1.5)
        }) { [weak self] (failureModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
        }
    }
    //MARK: - 绑定设备
    private func bindDeviceByValudateIMEI(imeiStr:String) {
        guard imeiStr.isEmpty == false else {
            return
        }
        var paramters:Dictionary<String, Any> = Dictionary()
        paramters["imei"] = imeiStr.valueStr
        if let value = CBPetLoginModelTool.getUser()?.uid {
            paramters["adminId"] = value.valueStr
        }
        ///绑定类型（0：普通绑定 1：管理员添加的方式直接绑定）
        paramters["bindType"] = "0"
        CBPetNetworkingManager.share.bindDeviceByValudateIMEIRequest(paramters: paramters, successBlock: { [weak self] (successModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
            ///返回错误信息
            guard successModel.status == "0" else {
                if successModel.rescode == "0030" {
                    MBProgressHUD.showMessage(Msg: "您已经绑定了这个设备".localizedStr, Deleay: 2.0)
                    return
                }
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 2.0)
                return;
            }
            //MBProgressHUD.showMessage(Msg: "绑定成功".localizedStr, Deleay: 1.5)
            let ddJson = JSON.init(successModel.data as Any)
            let scanModel = CBPetScanResultModel.deserialize(from: ddJson.dictionaryObject)
            /* 设备第一次被绑定，提示去编辑宠物寂寥*/
            if scanModel?.isAdmin == "1" {
                self?.bindSuccess(imeiStr:scanModel?.imei ?? "",petId:scanModel?.petId ?? "")
            } else if scanModel?.isAdmin == "0" {
                self?.navigationController?.popToRootViewController(animated: true)
            } else {
                self?.navigationController?.popToRootViewController(animated: true)
            }
        }) { [weak self] (failureModel) in
            if let value = self?.view {
                MBProgressHUD.hide(for: value, animated: true)
            }
        }
    }
    //MARK: - 绑定成功页面
    private func bindSuccess(imeiStr:String,petId:String) {
        let bindSuccessVC = CBPetBindSuccessVC.init()
        bindSuccessVC.imeiStr = imeiStr
        bindSuccessVC.petId = petId
        self.navigationController?.pushViewController(bindSuccessVC, animated: true)
    }
    //该方法中，_preViewLayer指的是AVCaptureVideoPreviewLayer的实例对象，
    //_session是会话对象，_metadataOutput是扫码输出流
    private func coverToMetadataOutputRectOfInterestForRect(cropRect:CGRect) {
        let size = self.previewLayer?.bounds.size ?? CGSize(width: 0, height: 0)
        let p1:CGFloat = size.height/size.width
        var p2:CGFloat = 0.0
        if self.session?.sessionPreset == AVCaptureSession.Preset.hd1920x1080 {
            p2 = 1920.0/1080
        }
//        else if self.session?.sessionPreset == AVCaptureSession.Preset.hd352x288 {
//        }
        else if self.session?.sessionPreset == AVCaptureSession.Preset.hd1280x720 {
            p2 = 1280.0/720.0;
        } else if self.session?.sessionPreset == AVCaptureSession.Preset.iFrame960x540 {
            p2 = 960.0/540.0;
        } else if self.session?.sessionPreset == AVCaptureSession.Preset.iFrame1280x720 {
            p2 = 1280.0/720.0;
        } else if self.session?.sessionPreset == AVCaptureSession.Preset.high {
            p2 = 1920.0/1080.0;
        } else if self.session?.sessionPreset == AVCaptureSession.Preset.medium {
            p2 = 480.0/360.0;
        } else if self.session?.sessionPreset == AVCaptureSession.Preset.low {
            p2 = 192.0/144.0;
        } else if self.session?.sessionPreset == AVCaptureSession.Preset.photo {// 暂时未查到具体分辨率，但是可以推导出分辨率的比例为4/3
            p2 = 4.0/3.0;
        } else if self.session?.sessionPreset == AVCaptureSession.Preset.inputPriority {
            p2 = 1920.0/1080.0;
        } else if #available(iOS 9.0, *) {
            if self.session?.sessionPreset == AVCaptureSession.Preset.hd4K3840x2160 {
                p2 = 3840.0/2160.0;
            }
        }
        
        if self.previewLayer?.videoGravity == AVLayerVideoGravity.resize {
            self.metadataOut.rectOfInterest = CGRect.init(x:cropRect.origin.y/size.height , y: (size.width-(cropRect.size.width+cropRect.origin.x))/size.width, width: cropRect.size.height/size.height, height: cropRect.size.width/size.width)
        } else if self.previewLayer?.videoGravity == AVLayerVideoGravity.resizeAspectFill {
            if p1 < p2 {
                let fixHeight = size.width*p2
                let fixPadding = (fixHeight - size.height)/2
                self.metadataOut.rectOfInterest = CGRect.init(x:(cropRect.origin.y+fixPadding)/fixHeight, y: (size.width-(cropRect.size.width+cropRect.origin.x))/size.width, width: cropRect.size.height/fixHeight, height: cropRect.size.width/size.width)
            } else {
                let fixWidth = size.height*(1/p2)
                let fixPadding = (fixWidth - size.width)/2
                self.metadataOut.rectOfInterest = CGRect.init(x:(cropRect.origin.y/size.height), y: (size.width-(cropRect.size.width+cropRect.origin.x)+fixPadding)/fixWidth, width: cropRect.size.height/size.height, height: cropRect.size.width/fixWidth)
            }
        } else {
            if p1 > p2 {
                let fixHeight = size.width*p2
                let fixPadding = (fixHeight - size.height)/2
                self.metadataOut.rectOfInterest = CGRect.init(x:(cropRect.origin.y+fixPadding)/fixHeight, y: (size.width-(cropRect.size.width+cropRect.origin.x))/size.width, width: cropRect.size.height/fixHeight, height: cropRect.size.width/size.width)
            } else {
                let fixWidth = size.height*(1/p2)
                let fixPadding = (fixWidth - size.width)/2
                self.metadataOut.rectOfInterest = CGRect.init(x:cropRect.origin.y/size.height, y: (size.width-(cropRect.size.width+cropRect.origin.x)+fixPadding)/fixWidth, width: cropRect.size.height/size.height, height: cropRect.size.width/fixWidth)
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
