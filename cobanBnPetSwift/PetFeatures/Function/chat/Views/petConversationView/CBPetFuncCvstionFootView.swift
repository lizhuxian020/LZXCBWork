//
//  CBPetFuncCvstionFootView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/1.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit
import AVFoundation

/* 录音文件夹名*/
let KPetFunc_chat_Audio_data = "KPetFunc_chat_Audio_data"

class CBPetFuncCvstionFootView: CBPetBaseView,UIGestureRecognizerDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    private lazy var shadowBgmView:UIView = {
        let bgmV = UIView(backgroundColor: UIColor.white, cornerRadius: 16*KFitHeightRate, shadowColor: KPetC8C8C8Color, shadowOpacity: 0.35, shadowOffset: CGSize(width: 4, height: 0), shadowRadius: 8)
        return bgmV
    }()
    private lazy var bgmView:UIView = {
        let bgmV = UIView.init()
        bgmV.backgroundColor = UIColor.white
        return bgmV
    }()
    private lazy var swtichBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton(imageName: "pet_func_chat_switchVoice")
        btn.setImage(UIImage(named: "pet_func_chat_switchText"), for: .selected)
        return btn
    }()
    private lazy var holdBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton(title: "按住说话".localizedStr, titleColor: KPetTextColor, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!, borderWidth: 1, borderColor: KPetLineColor, cornerRadius: 15*KFitHeightRate)
        btn.setTitle("松开发送".localizedStr, for: .selected)
        btn.isHidden = true
        return btn
    }()
    private lazy var inputTF:UITextField = {
        let tf = UITextField(text: "", textColor: KPetTextColor, font: UIFont(name: CBPingFangSC_Regular, size: 14)!, placeholder: "输入消息".localizedStr,cornerRadius:15*KFitHeightRate)
        tf.backgroundColor = KPetLineColor
        let leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: 17*KFitWidthRate, height: 30*KFitHeightRate))
        tf.leftViewMode = .always
        tf.leftView = leftView
        return tf
    }()
    private lazy var sendBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton(imageName: "pet_func_chat_send")
        return btn
    }()
    public lazy var popRecordingView:CBPetFuncSendVoiceView = {
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        self.audioTemporarySavePath = "\(NSHomeDirectory())/tmp/temporaryChat.wav"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let maskPath = UIBezierPath.init(roundedRect: self.bgmView.bounds, byRoundingCorners: UIRectCorner(rawValue: UIRectCorner.topLeft.rawValue | UIRectCorner.topRight.rawValue), cornerRadii: CGSize(width: 16*KFitHeightRate, height: 16*KFitHeightRate))
        let maskLayer = CAShapeLayer.init()
        /* 设置大小*/
        maskLayer.frame = self.bgmView.bounds
        /* 设置图形样子*/
        maskLayer.path = maskPath.cgPath
        self.bgmView.layer.mask = maskLayer
    }
    override func setupViewModel(viewModel: Any) {
        self.viewModel = viewModel
    }
    private func setupView() {
        self.backgroundColor = UIColor.init().colorWithHexString(hexString: "#222222", alpha: 0.00)

        self.addSubview(self.shadowBgmView)
        self.shadowBgmView.snp_makeConstraints { (make) in
            make.center.equalTo(self)
            make.size.equalTo(CGSize(width: SCREEN_WIDTH, height: 100*KFitHeightRate))
        }
        self.addSubview(self.bgmView)
        self.bgmView.snp_makeConstraints { (make) in
            make.left.top.right.equalTo(self)
            make.size.equalTo(CGSize(width: SCREEN_WIDTH, height: 100*KFitHeightRate))
        }
        
        UIApplication.shared.keyWindow?.addSubview(self.popRecordingView)
        //self.addSubview(self.popRecordingView)
        self.popRecordingView.snp_makeConstraints { (make) in
            make.center.equalTo(UIApplication.shared.keyWindow!)
            make.size.equalTo(CGSize(width: 120*KFitWidthRate, height: 125*KFitWidthRate))
        }
        
        self.bgmView.addSubview(self.holdBtn)
        self.holdBtn.snp_makeConstraints { (make) in
            make.top.equalTo(self.bgmView.snp_top).offset(10*KFitHeightRate)
            make.left.equalTo(60*KFitWidthRate)
            make.size.equalTo(CGSize(width: SCREEN_WIDTH - 120*KFitWidthRate, height: 30*KFitHeightRate))
        }
        
        self.bgmView.addSubview(self.inputTF)
        self.inputTF.snp_makeConstraints { (make) in
            make.top.equalTo(self.bgmView.snp_top).offset(10*KFitHeightRate)
            make.centerX.equalTo(self.bgmView)
            make.size.equalTo(CGSize(width: SCREEN_WIDTH - 120*KFitWidthRate, height: 30*KFitHeightRate))
        }
        
        let switchVoiceImage = UIImage(named: "pet_func_chat_switchVoice")!
        self.bgmView.addSubview(self.swtichBtn)
        self.swtichBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.holdBtn)
            make.left.equalTo(20*KFitWidthRate)
            make.size.equalTo(CGSize(width: switchVoiceImage.size.width, height: switchVoiceImage.size.height))
        }
        self.swtichBtn.addTarget(self, action: #selector(switchVoiceAndText), for: .touchUpInside)
     
        let sendImage = UIImage(named: "pet_func_chat_send")!
        self.bgmView.addSubview(self.sendBtn)
        self.sendBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.holdBtn)
            make.right.equalTo(-20*KFitWidthRate)
            make.size.equalTo(CGSize(width: sendImage.size.width, height: sendImage.size.height))
        }
        self.sendBtn.addTarget(self, action: #selector(sendMsgAction), for: .touchUpInside)
        
        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(longPressAction))
        longPress.minimumPressDuration = 0.0;
        longPress.delegate = self;
        //将触摸事件添加到当前view
        self.holdBtn.addGestureRecognizer(longPress)
    }
    @objc private func switchVoiceAndText(sender:CBPetBaseButton) {
        sender.isSelected = !sender.isSelected
        self.inputTF.isHidden = sender.isSelected
        self.holdBtn.isHidden = !sender.isSelected
        
        if self.holdBtn.isHidden == false {
            /* 发送语音状态下 ,结束编辑*/
            self.endEditing(true)
            self.sendBtn.isHidden = true
            self.holdBtn.snp_updateConstraints { (make) in
                make.top.equalTo(self.bgmView.snp_top).offset(10*KFitHeightRate)
                make.left.equalTo(60*KFitWidthRate)
                make.size.equalTo(CGSize(width: SCREEN_WIDTH - 80*KFitWidthRate, height: 30*KFitHeightRate))
            }
        } else {
            self.sendBtn.isHidden = false
            self.holdBtn.snp_updateConstraints { (make) in
                make.top.equalTo(self.bgmView.snp_top).offset(10*KFitHeightRate)
                make.left.equalTo(60*KFitWidthRate)
                make.size.equalTo(CGSize(width: SCREEN_WIDTH - 120*KFitWidthRate, height: 30*KFitHeightRate))
            }
        }
    }
    func cleanInputMsg() {
        self.inputTF.text = ""
    }
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    //MARK: - 长按响应
    @objc private func longPressAction(press:UITapGestureRecognizer) {
        /* 麦克风权限*/
        if CBPetUtils.checkMicrophonePermission(resultBlock: { (isAllow) in
            if isAllow == false {
                return
            }
        }) == false {
            return
        }
        let point = press.location(in: self.bgmView)
        switch press.state {
        case .began:
            /* 开始*/
            CBLog(message: "长按开始")
            self.popRecordingView.isHidden = false
            self.popRecordingView.normalSendVoiceUI()
            self.updatePressBtnAndIsExistVoice(title: "松开发送".localizedStr)
            self.recordMethod()
            break
        case .ended:
            /* 结束*/
            CBLog(message: "长按结束")
            self.popRecordingView.isHidden = true
            if (self.timeCount < 1) {
                /* 录音时间过短 删除录音*/
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
            self.updatePressBtnAndIsExistVoice(title: "按住说话".localizedStr)
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
            self.updatePressBtnAndIsExistVoice(title: "按住说话".localizedStr)
            self.resetTimerMethod()
            break
        case .cancelled:
            /* 取消*/
            CBLog(message: "长按取消")
            self.popRecordingView.isHidden = true
            self.updatePressBtnAndIsExistVoice(title: "按住说话".localizedStr)
            self.resetTimerMethod()
            break
        default:
            break
        }
    }
    //MARK: - 发送文本按钮
    @objc private func sendMsgAction() {
        self.inputTF.resignFirstResponder()
        guard self.inputTF.text?.isEmpty == false else {
            return
        }
        if self.viewModel is CBPetFuncChatViewModel {
            let vvModel = self.viewModel as! CBPetFuncChatViewModel
            guard vvModel.petfriendCvstionChatBlock == nil else {
                vvModel.petfriendCvstionChatBlock!(self.inputTF.text as Any,"0",0)
                return
            }
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
        let filePath = "".createFilePath(folderName:KPetFunc_chat_Audio_data,formateStr:".amr")
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
            if self.viewModel is CBPetFuncChatViewModel {
                let vvModel = self.viewModel as! CBPetFuncChatViewModel
                guard vvModel.petfriendCvstionChatBlock == nil else {
                    vvModel.petfriendCvstionChatBlock!(self.lastRecordFilePath as Any,"1",self.timeCount)
                    /* 重置时间*/
                    self.resetTimerMethod()
                    return
                }
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

    private func updatePressBtnAndIsExistVoice(title:String) {
        self.holdBtn.setTitle(title, for: .normal)
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
