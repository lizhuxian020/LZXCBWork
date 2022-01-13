//
//  CBPetFunctionShoutView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/5/27.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit
import AVFoundation

/* 录音文件夹名*/
let KPet_func_shout_Audio_data = "KPet_func_shout_Audio_data"

class CBPetFunctionShoutView: CBPetBaseView,UIGestureRecognizerDelegate,AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    private lazy var topNoteLb:UILabel = {
        let lb = UILabel(text: String(format: "%@%@%@", "正在对您的宠物".localizedStr,"“" + (CBPetHomeInfoTool.getHomeInfo().pet.name ?? "") + "“","喊话，".localizedStr), textColor: UIColor.white, font: UIFont.init(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!, textAlignment: .center)
        return lb
    }()
    private lazy var dissmissBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton.init()
        btn.setTitle("退出喊话".localizedStr, for: .normal)
        btn.setTitle("退出喊话".localizedStr, for: .highlighted)
        btn.titleLabel?.font = UIFont.init(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)
        btn.setTitleColor(KPetAppColor, for: .normal)
        btn.setTitleColor(KPetAppColor, for: .highlighted)
        return btn
    }()
    private lazy var cornerMaxView:UIView = {
        let vv = UIView.init()
        vv.layer.cornerRadius = 80*KFitWidthRate
        vv.backgroundColor = UIColor.init().colorWithHexString(hexString: "#FFFFFF", alpha: 0.05)
        return vv
    }()
    private lazy var holdBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton.init()
        btn.setImage(UIImage.init(named: "pet_function_voice_pres"), for: .normal)
        btn.setImage(UIImage.init(named: "pet_function_voice_pres"), for: .highlighted)
        btn.backgroundColor = UIColor.white
        btn.layer.cornerRadius = 40*KFitWidthRate
        return btn
    }()
    private lazy var popRecordingView:CBPetFuncSendVoiceView = {
        let recordingV = CBPetFuncSendVoiceView.init()
        recordingV.backgroundColor = UIColor.init().colorWithHexString(hexString: "#222222", alpha: 0.85)
        recordingV.layer.masksToBounds = true;
        recordingV.layer.cornerRadius = 12*KFitHeightRate;
        recordingV.isHidden = true;
        return recordingV
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
    var finishRcordBlock:((_ filePath:String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        self.audioTemporarySavePath = "\(NSHomeDirectory())/tmp/temporaryRecord_shout.wav"
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupView() {
        self.backgroundColor = KPetNavigationBarColor
        //self.topNoteLb = UILabel(text: String(format: "%@%@%@", "正在对您的宠物".localizedStr,CBPetHomeInfoTool.getHomeInfo().pet.name ?? "","喊话，".localizedStr), textColor: UIColor.white, font: UIFont.init(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!, textAlignment: .center)
        self.addSubview(self.topNoteLb)
        self.topNoteLb.snp_makeConstraints { (make) in
            make.top.equalTo(160*KFitHeightRate)
            make.centerX.equalTo(self)
        }
        
        let bottomLb = UILabel(text: "请长按下面按钮说话，松手自动发送".localizedStr, textColor: UIColor.white, font: UIFont.init(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!, textAlignment: .center)
        self.addSubview(bottomLb)
        bottomLb.snp_makeConstraints { (make) in
            make.top.equalTo(topNoteLb.snp_bottom).offset(10*KFitHeightRate)
            make.centerX.equalTo(self)
            make.left.equalTo(self.snp_left).offset(10*KFitWidthRate)
            make.right.equalTo(self.snp_right).offset(-10*KFitWidthRate)
        }
        
        self.addSubview(self.popRecordingView)
        self.popRecordingView.snp_makeConstraints { (make) in
            make.center.equalTo(self)
            make.size.equalTo(CGSize(width: 120*KFitWidthRate, height: 125*KFitWidthRate))
        }
        
        self.addSubview(self.cornerMaxView)
        self.cornerMaxView.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.bottom.equalTo(28*KFitHeightRate - CGFloat(TabPaddingBARHEIGHT))
            make.size.equalTo(CGSize(width: 160*KFitWidthRate, height: 160*KFitWidthRate))
        }
        
        let cornerMiddleView = UIView.init()
        cornerMiddleView.layer.cornerRadius = 60*KFitWidthRate
        cornerMiddleView.backgroundColor = UIColor.init().colorWithHexString(hexString: "#FFFFFF", alpha: 0.1)
        self.addSubview(cornerMiddleView)
        cornerMiddleView.snp_makeConstraints { (make) in
            make.center.equalTo(cornerMaxView)
            make.size.equalTo(CGSize(width: 120*KFitWidthRate, height: 120*KFitWidthRate))
        }
        
        self.addSubview(self.holdBtn)
        self.holdBtn.snp_makeConstraints { (make) in
            make.center.equalTo(cornerMaxView)
            make.size.equalTo(CGSize(width: 80*KFitWidthRate, height: 80*KFitWidthRate))
        }
        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(longPressAction))
        longPress.minimumPressDuration = 0.0;
        longPress.delegate = self;
        //将触摸事件添加到当前view
        self.holdBtn.addGestureRecognizer(longPress)
        
        self.addSubview(self.dissmissBtn)
        self.dissmissBtn.addTarget(self, action: #selector(dissmiss), for: .touchUpInside)
        self.dissmissBtn.underline()
        self.dissmissBtn.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.height.equalTo(15*KFitHeightRate)
            make.bottom.equalTo(cornerMaxView.snp_top).offset(-32*KFitHeightRate)
        }
    }
    public func popView() {
        UIApplication.shared.keyWindow?.addSubview(self)
        self.topNoteLb.text = String(format: "%@%@%@", "正在对您的宠物".localizedStr," \"" + (CBPetHomeInfoTool.getHomeInfo().pet.name ?? "") + "\" ","喊话，".localizedStr)
    }
    @objc private func dissmiss() {
        /* 重置录音时间*/
        self.resetTimerMethod()
        self.removeFromSuperview()
    }
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    @objc private func longPressAction(press:UITapGestureRecognizer) {
        let point = press.location(in: self.cornerMaxView)
        //print("长按的点:\(point)")
        //print("长按的范围:\(self.cornerMaxView.frame)")
        /* 判断该区域是否包含某个指定的区域 */
        if self.cornerMaxView.frame.contains(point) {
            ///return false
        }
        switch press.state {
        case .began:
            /* 开始*/
            CBLog(message: "长按开始")
            self.popRecordingView.normalSendVoiceUI()
            self.popRecordingView.isHidden = false
            self.recordMethod()
            break
        case .ended:
            /* 结束*/
            CBLog(message: "长按结束")
            self.popRecordingView.isHidden = true
            if (self.timeCount < 1 ) {
                /* 录音时间过短、 删除录音*/
                MBProgressHUD.showMessage(Msg: "录音时间过短".localizedStr, Deleay: 1.0)
                self.resetTimerMethod()
                /* 录音时间过短 删除录音 */
                self.audioRecorder?.stop()
                self.audioRecorder?.deleteRecording()
            } else if point.y < 0 {
                /* 手指上滑超过范围,取消发送*/
                self.resetTimerMethod()
                /* 录音时间过短 删除录音 */
                self.audioRecorder?.stop()
                self.audioRecorder?.deleteRecording()
            } else {
                /* 结束录音 */
                self.audioRecorder?.stop()
            }
            break
        case .changed:
            /* 长按中*/
            if point.y < 0 {
                /* 手指上滑超过范围,显示取消发送UI*/
                self.popRecordingView.cancelSendVoiceUI()
            } else {
                self.popRecordingView.normalSendVoiceUI()
            }
            break
        case .failed:
            /* 失败*/
            CBLog(message: "长按失败")
            self.popRecordingView.isHidden = true
            self.resetTimerMethod()
            break
        case .cancelled:
            /* 取消*/
            CBLog(message: "长按取消")
            self.popRecordingView.isHidden = true
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
        let filePath = "".createFilePath(folderName:KViewController_Audio_data,formateStr:".amr")
        /* 这里为了验证录制成功，并播放上一次的录制，我们记录一下这次的文件地址*/
        self.lastRecordFilePath = filePath
        #if TARGET_IPHONE_SIMULATOR
            let url = NSURL.fileURL(withPath: self.audioTemporarySavePath)
        #else //TARGET_OS_IPHONE
            let url = NSURL.init(string: self.audioTemporarySavePath!)
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
        
        /* 录音超过1s时，播放录音*/
        if self.timeCount >= 1 {
            /* 播放录音*/
            //self.playRecordingMethod()
            
            guard self.lastRecordFilePath?.isEmpty == false else {
                /* 重置时间*/
                self.resetTimerMethod()
                return
            }
            guard self.finishRcordBlock == nil else {
                self.resetTimerMethod()
                self.finishRcordBlock!(self.lastRecordFilePath!)
                return
            }
            
            /* 重置时间*/
            //self.resetTimerMethod()
        }
    }
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        CBLog(message: "录音出现了错误 = \(error?.localizedDescription ?? "")")
    }
    //MARK: - 播放录音
    @objc private func playRecordingMethod() {
        CBLog(message: "播放录音 播放录音 播放录音 播放录音")
        //MBProgressHUD.showMessage(Msg: "暂无录音", Deleay: 1.0)
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
    //MARK: - 定时器相关
    @objc private func timeMove() {
        self.timeCount += 1
        if self.timeCount == 0 {
            self.voiceTimer?.invalidate()
            self.voiceTimer = nil
        }
        self.setTotalTime(totalTime: self.timeCount)
    }
    func resetTimerMethod() {
        self.voiceTimer?.invalidate()
        self.voiceTimer = nil
        self.timeCount = 0
        self.setTotalTime(totalTime: self.timeCount)
    }
    func setTotalTime(totalTime:NSInteger) {
        let ms = totalTime
        let ss = 1
        let mi = ss*60
        let hh = mi*60
        let dd = hh*24
        
        let day = ms/dd
        let hour = (ms - day*dd)/hh

        let minute = (ms - day*dd - hour*hh)/mi
        let second = (ms - day*dd - hour*hh - minute*mi)/ss
        let time = String.init(format: "%01ld:%02ld", minute,second)
        
        self.popRecordingView.titleLb.text = time
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
