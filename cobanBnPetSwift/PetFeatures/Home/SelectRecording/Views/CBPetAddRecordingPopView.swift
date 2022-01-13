//
//  CBPetAddRecordingPopView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/5/28.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit
import AVFoundation

/* 录音文件夹名*/
let KViewController_Audio_data = "kViewController_Audio_data"

class CBPetAddRecordingPopView: CBPetBaseView,UIGestureRecognizerDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    private lazy var recordView:UIView = {
        let recordV = UIView.init(frame: CGRect.init(x: 0, y: SCREEN_HEIGHT - 240*KFitHeightRate - CGFloat(TabPaddingBARHEIGHT), width: SCREEN_WIDTH, height: 240*KFitHeightRate + CGFloat(TabPaddingBARHEIGHT)))
        recordV.backgroundColor = UIColor.white
        return recordV
    }()
    private var topNoteLb:UILabel = {
        let lb = UILabel(text: "在当前环境下，请您保持安静，并点击“开始录音”".localizedStr, textColor: KPet666666Color, font: UIFont.init(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!, textAlignment: .center)
        return lb
    }()
    private var bottomNoteLb:UILabel = {
        let lb = UILabel(text: "按钮，以便采集环境噪音".localizedStr, textColor: KPet666666Color, font: UIFont.init(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!, textAlignment: .center)
        return lb
    }()
    private var secondLb:UILabel = {
        let lb = UILabel(text: "0s".localizedStr, textColor: KPetTextColor, font: UIFont.init(name: CBPingFangSC_Regular, size: 36*KFitHeightRate)!, textAlignment: .center)
        return lb
    }()
    private var cancelBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton.init(imageName: "pet_function_shout_cancel")
        btn.isHidden = true
        return btn
    }()
    private var comfirmBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton.init(imageName: "pet_function_shout_comfirm")
        btn.isHidden = true
        return btn
    }()
    private var recordButton:CBPetBaseButton = {
        let btn = CBPetBaseButton.init(title: "开始录音".localizedStr, titleColor: UIColor.white, font: UIFont.init(name: CBPingFangSC_Regular, size: 16*KFitHeightRate)!)
        btn.setShadow(backgroundColor: KPetAppColor, cornerRadius:20*KFitHeightRate,shadowColor: KPetAppColor, shadowOpacity: 0.35, shadowOffset: CGSize(width: 4, height: 0), shadowRadius: 8)
        return btn
    }()
    private var playButton:CBPetBaseButton = {
        let btn = CBPetBaseButton.init(title: "播放录音".localizedStr, titleColor: UIColor.white, font: UIFont.init(name: CBPingFangSC_Regular, size: 16*KFitHeightRate)!)
        btn.setShadow(backgroundColor: KPetAppColor, cornerRadius:20*KFitHeightRate,shadowColor: KPetAppColor, shadowOpacity: 0.35, shadowOffset: CGSize(width: 4, height: 0), shadowRadius: 8)
        btn.isHidden = true
        return btn
    }()
    private var timeCount:NSInteger = 0
    private var voiceTimer:Timer?
    private var audioRecorder:AVAudioRecorder?
    private var audioPlayer:AVAudioPlayer?
    private var audioTemporarySavePath:String?
    private var lastRecordFilePath:String?
    private var audioSettingDic:[String:Any] = {
        var recordingSetting = [String:Any]()
        /* 设置录音格式 */
        recordingSetting[AVFormatIDKey] = NSNumber(value: kAudioFormatLinearPCM)
        /* 设置录音采样率，8000是电话采样率，对于一般录音已经够了 */
        recordingSetting[AVSampleRateKey] = NSNumber(value: 8000)///8000
        /* 设置通道,这里采用单声道 1为单声道，2为立体声*/
        recordingSetting[AVNumberOfChannelsKey] = NSNumber(value:1)
        /* 质量*/
        recordingSetting[AVEncoderAudioQualityKey] = NSNumber(value: AVAudioQuality.low.rawValue)
        /* 每个采样点位数,分为8、16、24、32  @(16) */
        recordingSetting[AVLinearPCMBitDepthKey] = NSNumber(value: 16)
        //是否使用浮点数采样 wav格式时 设置false
        //[dict setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
        recordingSetting[AVLinearPCMIsFloatKey] = NSNumber(value: false)
        /* YES: 大端模式 NO: 小端模式*/
        recordingSetting[AVLinearPCMIsBigEndianKey] = NSNumber(value: false)
        /* 交叉的*/
        recordingSetting[AVLinearPCMIsNonInterleaved] = NSNumber(value: false)
        return recordingSetting
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        self.audioTemporarySavePath = "\(NSHomeDirectory())/tmp/temporaryRecord.wav"
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setupViewModel(viewModel: Any) {
        self.viewModel = viewModel
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let maskPath = UIBezierPath.init(roundedRect: self.recordView.bounds, byRoundingCorners: UIRectCorner(rawValue: UIRectCorner.topLeft.rawValue | UIRectCorner.topRight.rawValue), cornerRadii: CGSize(width: 16*KFitHeightRate, height: 16*KFitHeightRate))
        let maskLayer = CAShapeLayer.init()
        /* 设置大小*/
        maskLayer.frame = self.recordView.bounds
        /* 设置图形样子*/
        maskLayer.path = maskPath.cgPath
        self.recordView.layer.mask = maskLayer
    }
    private func setupView() {
        self.backgroundColor = UIColor.init().colorWithHexString(hexString: "#222222", alpha: 0.85)
        
        let tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapGestureMethod))
        //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
        tapGestureRecognizer.cancelsTouchesInView = false;
        tapGestureRecognizer.delegate = self;
        //将触摸事件添加到当前view
        self.addGestureRecognizer(tapGestureRecognizer)
        
        self.addSubview(self.recordView)
        
        self.recordView.addSubview(self.topNoteLb)
        self.topNoteLb.snp_makeConstraints { (make) in
            make.top.equalTo(30*KFitHeightRate)
            make.left.right.equalTo(0)
        }
        
        self.recordView.addSubview(self.bottomNoteLb)
        self.bottomNoteLb.snp_makeConstraints { (make) in
            make.top.equalTo(self.topNoteLb.snp_bottom).offset(5*KFitHeightRate)
            make.left.right.equalTo(0)
        }
        
        self.recordView.addSubview(self.secondLb)
        self.secondLb.snp_makeConstraints { (make) in
            make.top.equalTo(self.bottomNoteLb.snp_bottom).offset(30*KFitHeightRate)
            make.centerX.equalTo(self.snp_centerX)
        }
        
        let cancelImage = UIImage.init(named: "pet_function_shout_cancel")!
        let comfirmImage = UIImage.init(named: "pet_function_shout_comfirm")!
        self.recordView.addSubview(self.cancelBtn)
        self.cancelBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.secondLb.snp_centerY)
            make.left.equalTo(50*KFitWidthRate)
            make.size.equalTo(CGSize(width: cancelImage.size.width, height: cancelImage.size.height))
        }
        self.cancelBtn.addTarget(self, action: #selector(cancelClick), for: .touchUpInside)
        self.recordView.addSubview(self.comfirmBtn)
        self.comfirmBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.secondLb.snp_centerY)
            make.right.equalTo(-50*KFitWidthRate)
            make.size.equalTo(CGSize(width: comfirmImage.size.width, height: comfirmImage.size.height))
        }
        self.comfirmBtn.addTarget(self, action: #selector(comfirmClick), for: .touchUpInside)
        
        self.recordView.addSubview(self.recordButton)
        self.recordButton.snp_makeConstraints { (make) in
            make.top.equalTo(self.secondLb.snp_bottom).offset(30*KFitHeightRate)
            make.left.equalTo(50*KFitWidthRate)
            make.right.equalTo(-50*KFitWidthRate)
            make.height.equalTo(40*KFitHeightRate)
        }
        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(longPressAction))
        longPress.minimumPressDuration = 0.0;
        longPress.delegate = self;
        //将触摸事件添加到当前view
        self.recordButton.addGestureRecognizer(longPress)
        
        self.recordView.addSubview(self.playButton)
        self.playButton.snp_makeConstraints { (make) in
            make.top.equalTo(self.secondLb.snp_bottom).offset(30*KFitHeightRate)
            make.left.equalTo(50*KFitWidthRate)
            make.right.equalTo(-50*KFitWidthRate)
            make.height.equalTo(40*KFitHeightRate)
        }
        self.playButton.addTarget(self, action: #selector(playRecordingMethod), for: .touchUpInside)
    }
    @objc private func tapGestureMethod(tap:UITapGestureRecognizer) {
        self.dissmiss()
    }
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        /* 判断该区域是否包含某个指定的区域 */
        if self.recordView.frame.contains(gestureRecognizer.location(in: self)) {
            if (self.recordButton.frame.contains(gestureRecognizer.location(in: self.recordView)) && self.recordButton.isHidden == false) {
                return true
            }
            return false
        }
        return true
    }
    public func popView() {
        UIApplication.shared.keyWindow?.addSubview(self)
        /* 初始化各项*/
        self.updatePressBtnAndIsExistVoice(title: "开始录音".localizedStr)
    }
    public func dissmiss() {
        ///删除录音
        if self.audioRecorder?.deleteRecording() ?? false {
            CBLog(message: "删除录音成功")
        }
        /* 重置录音时间*/
        self.resetTimerMethod()
        self.removeFromSuperview()
    }
    //MARK: - 长按响应
    @objc private func longPressAction(press:UITapGestureRecognizer) {
        //let point = press.location(in: self.recordButton)
        switch press.state {
        case .began:
            /* 开始*/
            CBLog(message: "长按开始")
            self.updatePressBtnAndIsExistVoice(title: "录制中 ...".localizedStr)
            self.recordMethod()
            break
        case .ended:
            /* 结束*/
            CBLog(message: "长按结束")
            /* 录音时间过短 删除录音*/
            if (self.timeCount < 1) {
                MBProgressHUD.showMessage(Msg: "录音时间过短".localizedStr, Deleay: 1.0)
                self.resetTimerMethod()
                /* 录音时间过短 删除录音 */
                self.audioRecorder?.stop()
                self.audioRecorder?.deleteRecording()
            } else {
                /* 结束录音 */
                self.audioRecorder?.stop()
            }
            self.updatePressBtnAndIsExistVoice(title: "开始录音".localizedStr)
            break
        case .changed:
            /* 长按中*/
            //print("长按中")
            break
        case .failed:
            /* 失败*/
            CBLog(message: "长按失败")
            self.updatePressBtnAndIsExistVoice(title: "开始录音".localizedStr)
            self.resetTimerMethod()
            break
        case .cancelled:
            /* 取消*/
            CBLog(message: "长按取消")
            self.updatePressBtnAndIsExistVoice(title: "开始录音".localizedStr)
            self.resetTimerMethod()
            break
        default:
            break
        }
    }
    //MARK: - 录音action
    private func recordMethod() {
        /* 停止当前的播放 */
        self.audioPlayer?.stop()
        self.audioPlayer = nil
        
        /* 释放之前的对象*/
        self.audioRecorder?.stop()
        self.audioRecorder = nil
        
        /* 创建新的录制对象 */
        //self.creatFilePath()
        let filePath = "".createFilePath(folderName:KViewController_Audio_data,formateStr:".amr")
        /* 这里为了验证录制成功，并播放上一次的录制，我们记录一下这次的文件地址*/
        self.lastRecordFilePath = filePath
        #if TARGET_IPHONE_SIMULATOR
            let url = NSURL.fileURL(withPath: self.audioTemporarySavePath)
            //NSURL *url = [NSURL fileURLWithPath:self.audioTemporarySavePath];
        #else //TARGET_OS_IPHONE
            let url = NSURL.init(string: self.audioTemporarySavePath!)
            //NSURL *url = [NSURL URLWithString:self.audioTemporarySavePath];
        #endif
        do {
            let recorder = try AVAudioRecorder.init(url: url! as URL, settings: self.audioSettingDic)
            recorder.isMeteringEnabled = true
            self.audioRecorder = recorder
            self.audioRecorder?.delegate = self
            /* 开启设备设备录音模式*/
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord)
            try AVAudioSession.sharedInstance().setActive(true, options: AVAudioSession.SetActiveOptions.notifyOthersOnDeactivation)
            if (self.audioRecorder?.prepareToRecord())! {
                self.voiceTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timeMove), userInfo: nil, repeats: true)
                self.audioRecorder?.record()
            }
        } catch {
            CBLog(message: "创建音频失败")
        }
    }
    //MARK: - 录音delegate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        self.audioConvert()
    }
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        CBLog(message: "录音出现了错误 = \(error?.localizedDescription ?? "")")
    }
    //MARK: - 播放录音
    @objc private func playRecordingMethod() {
        CBLog(message: "播放录音 播放录音 播放录音 播放录音")
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true, options: AVAudioSession.SetActiveOptions.notifyOthersOnDeactivation)
            self.audioPlayer?.stop()
            self.audioPlayer = nil
            self.audioPlayer?.delegate = nil
            let data = NSData.init(contentsOfFile: self.lastRecordFilePath ?? "")
            let wavData = AudioConverter.getWAVEData(from: data as Data?)
            self.audioPlayer = try AVAudioPlayer.init(data: wavData!)
            self.audioPlayer?.delegate = self
            if (self.audioPlayer?.prepareToPlay())! {
                self.audioPlayer?.play()
            }
        } catch {
            CBLog(message: "音频播放器创建失败：%@",fileName: error.localizedDescription);
        }
    }
    //MARK: - 播放Delegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        player.stop()
        self.audioPlayer = nil
        CBLog(message: "播放成功!!")
    }
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        player.stop()
    }

    private func updatePressBtnAndIsExistVoice(title:String) {
        self.recordButton.setTitle(title, for: .normal)
        if self.timeCount >= 1 {
            /* 有录音*/
            self.comfirmBtn.isHidden = false
            self.cancelBtn.isHidden = false
            self.playButton.isHidden = false
            self.recordButton.isHidden = true
            /* 停止定时器*/
            self.voiceTimer?.invalidate()
            self.voiceTimer = nil
        } else {
            /* 无录音*/
            self.comfirmBtn.isHidden = true
            self.cancelBtn.isHidden = true
            self.playButton.isHidden = true
            self.recordButton.isHidden = false
        }
    }
    //MARK: - 取消
    @objc private func cancelClick() {
        self.dissmiss()
    }
    //MARK: - 确定
    @objc private func comfirmClick() {
        self.dissmiss()
        if self.viewModel is CBPetHomeViewModel {
            let vvModel = self.viewModel as! CBPetHomeViewModel
            guard vvModel.petHomeGoHomeRecordBlock == nil else {
                /* 重置时间*/
                self.resetTimerMethod()
                vvModel.petHomeGoHomeRecordBlock!("add",self.lastRecordFilePath as Any)
                return
            }
        }
    }
    //MARK: - 定时器相关
    @objc private func timeMove() {
        self.timeCount += 1
        if self.timeCount == 0 {
            self.voiceTimer?.invalidate()
            self.voiceTimer = nil
        }
        self.setTotalTime(totalTime: self.timeCount)
    }
    private func resetTimerMethod() {
        self.voiceTimer?.invalidate()
        self.voiceTimer = nil
        self.timeCount = 0
        self.setTotalTime(totalTime: self.timeCount)
    }
    private func setTotalTime(totalTime:NSInteger) {
        let ms = totalTime
        let ss = 1
        let mi = ss*60
        let hh = mi*60
        let dd = hh*24
        
        let day = ms/dd
        let hour = (ms - day*dd)/hh
        
        let minute = (ms - day*dd - hour*hh)/mi
        let second = (ms - day*dd - hour*hh - minute*mi)/ss
        let time = String.init(format: "%02ld:%02ld", minute,second)
        
        if minute <= 0 {
            self.secondLb.text = String.init(format: "%ds", second)
        } else {
            self.secondLb.text = String.init(format: "%@", time)
        }
    }
    //MARK: - -- wav ---> amr
    private func audioConvert() {
        let audioFileSavePath = self.lastRecordFilePath
        let result = AudioConverter.wav(toAmr: self.audioTemporarySavePath, amrSavePath: audioFileSavePath)
        if result == 1 {
            CBLog(message: "==========wav转amr格式音频文件成功");
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
