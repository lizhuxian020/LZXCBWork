//
//  CBPetChatPlayVoiceManager.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/29.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit
import AVFoundation

class CBPetChatPlayVoiceManager: NSObject,AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    ///单例
    static let share:CBPetChatPlayVoiceManager = {
        let view = CBPetChatPlayVoiceManager.init()
        return view
    }()
    private var audioPlayer:AVAudioPlayer?
    
    var playModel:Any? ///
    
    var playModelTemp:Any? ///
    var isEnd:Bool = true
    
    var playTalkVoiceEndBlock:((_ objc:Any) -> Void)?
    
    func playVoiceUrl(model:Any) { ///CBPetFuncCvstionModel
        self.playModel = model
        if self.isEnd == false {
        /* 有语音在播放了，再次点击时则停止播放 */
            self.audioPlayer?.stop()
            self.audioPlayer = nil
            self.audioPlayer?.delegate = nil
            var add_TimeStr = ""
            if self.playModelTemp is CBPetFuncCvstionModel {
                add_TimeStr = (self.playModelTemp as! CBPetFuncCvstionModel).add_time ?? ""
            } else if self.playModelTemp is CBPetHomeRcdListModel {
                add_TimeStr = (self.playModelTemp as! CBPetHomeRcdListModel).add_time ?? ""
            } else if self.playModelTemp is CBPetMsgCterModel {
                add_TimeStr = (self.playModelTemp as! CBPetMsgCterModel).addTime ?? ""
            }
            NotificationCenter.default.post(name: NSNotification.Name.init(String.init(format: "%@_stop",add_TimeStr)), object: nil)
            CBLog(message: "停止：发送通知\(String.init(format: "%@_stop",add_TimeStr))")
            self.isEnd = true
            return
        }
        self.isEnd = !self.isEnd
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true, options: AVAudioSession.SetActiveOptions.notifyOthersOnDeactivation)
            var playUrl = ""
            var add_TimeStr = ""
            if model is CBPetFuncCvstionModel {
                self.playModel = model as! CBPetFuncCvstionModel
                playUrl = (model as! CBPetFuncCvstionModel).message_file ?? ""
                add_TimeStr = (model as! CBPetFuncCvstionModel).add_time ?? ""
            } else if model is CBPetHomeRcdListModel {
                self.playModel = model as! CBPetHomeRcdListModel
                playUrl = (model as! CBPetHomeRcdListModel).file_path ?? ""
                add_TimeStr = (model as! CBPetHomeRcdListModel).add_time ?? ""
            } else if model is CBPetMsgCterModel {
                self.playModel = model as! CBPetMsgCterModel
                playUrl = (model as! CBPetMsgCterModel).listenFile ?? ""
                add_TimeStr = (model as! CBPetMsgCterModel).addTime ?? ""
            }
            CBPetNetworkingManager.share.downloadChatAudio(url: playUrl , successBlock: { (filePath) in
                /// wav ,aac,(amr不能)
                self.audioPlayer?.stop()
                self.audioPlayer = nil
                self.audioPlayer?.delegate = nil
                let wavAndAnyData = NSData.init(contentsOfFile: filePath) as Data?
                do {
                    self.audioPlayer = try AVAudioPlayer.init(data: wavAndAnyData ?? Data())
                    self.audioPlayer?.delegate = self
                    if (self.audioPlayer?.prepareToPlay())! {
                        self.audioPlayer?.play()
                    }
                    if self.isEnd == false {
                        self.playModelTemp = self.playModel
                        NotificationCenter.default.post(name: NSNotification.Name.init(String.init(format: "%@_begin",add_TimeStr)), object: nil)
                        CBLog(message: "播放：发送通知\(String.init(format: "%@_begin",add_TimeStr))")
                    }
                } catch {
                }
            }) { (filePath) in
            }

        } catch {
            CBLog(message: "音频播放器创建失败：%@",fileName: error.localizedDescription);
        }
    }
    //MARK: - 播放Delegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.playEnd()
        player.stop()
        self.audioPlayer = nil
        CBLog(message: "播放成功!!")
    }
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        self.playFailed()
        player.stop()
        CBLog(message: "播放错误")
    }
    func playFailed() {
        // 不可以播放
        self.isEnd = true
        var add_TimeStr = ""
        if self.playModel is CBPetFuncCvstionModel {
            add_TimeStr = (self.playModel as! CBPetFuncCvstionModel).add_time ?? ""
        } else if self.playModel is CBPetHomeRcdListModel {
            add_TimeStr = (self.playModel as! CBPetHomeRcdListModel).add_time ?? ""
        } else if self.playModel is CBPetMsgCterModel {
            add_TimeStr = (self.playModel as! CBPetMsgCterModel).addTime ?? ""
        }
        NotificationCenter.default.post(name: NSNotification.Name.init(String.init(format: "%@_stop",add_TimeStr)), object: nil)
        MBProgressHUD.showMessage(Msg: "播放失败".localizedStr, Deleay: 1.5)
    }
    func playEnd() {
        self.isEnd = true
        //播放百分比为1表示已经播放完毕
        var add_TimeStr = ""
        if self.playModel is CBPetFuncCvstionModel {
            add_TimeStr = (self.playModel as! CBPetFuncCvstionModel).add_time ?? ""
        } else if self.playModel is CBPetHomeRcdListModel {
            add_TimeStr = (self.playModel as! CBPetHomeRcdListModel).add_time ?? ""
        } else if self.playModel is CBPetMsgCterModel {
            add_TimeStr = (self.playModel as! CBPetMsgCterModel).addTime ?? ""
        }
        NotificationCenter.default.post(name: NSNotification.Name.init(String.init(format: "%@_stop",add_TimeStr)), object: nil)
        guard self.playTalkVoiceEndBlock == nil else {
            self.playTalkVoiceEndBlock!(self.playModel as Any)
            return
        }
    }
}
