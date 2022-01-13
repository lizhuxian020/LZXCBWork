//
//  CBPetSelectRecordingVC.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/5/28.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

class CBPetSelectRecordingVC: CBPetBaseViewController {

    private lazy var recordingListView:CBPetRecordingListView = {
        let vv = CBPetRecordingListView.init(frame: CGRect(x: 0,y: 0,width: SCREEN_WIDTH,height: SCREEN_HEIGHT))
        return vv
    }()
    private lazy var noRecordingView:CBPetNoRecordingView = {
        let vv = CBPetNoRecordingView.init(frame: CGRect(x: 0,y: 0,width: SCREEN_WIDTH,height: SCREEN_HEIGHT))
        return vv
    }()
    public lazy var homeViewModel:CBPetHomeViewModel = {
        let viewModel = CBPetHomeViewModel()
        return viewModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
        
        self.homeViewModel.getQNFileTokenRequestMethod()
        self.recordingListView.beginRefresh()
        updateDataSource()
    }
    private func setupView() {
        self.initBarWith(title: "请选择录音".localizedStr, isBack: true)
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.recordingListView)
        
        self.recordingListView.setupViewModel(viewModel: self.homeViewModel)
        self.homeViewModel.MJHeaderRefreshReloadDataBlock = { [weak self] (tag:Int) in
            self?.homeViewModel.getRecordListReuqest()
        }
        self.homeViewModel.MJFooterRefreshReloadDataBlock = { [weak self] (tag:Int) in
            self?.homeViewModel.getRecordListReuqest()
        }
    }
    
    // MARK: - 数据源刷新
    private func updateDataSource() {
        /* 获取，添加，删除录音 */
        self.homeViewModel.petHomeGoHomeRecordBlock = { [weak self] (type:String,objc:Any) -> Void in
            switch type {
            case "get":
                /* 录音列表数据源刷新*/
                if objc is [CBPetHomeRcdListModel] {
                    self?.recordingListView.endRefresh()
                    self?.recordingListView.updateRecordList(dataSource:objc as! [CBPetHomeRcdListModel])
                }
                break
            case "delete":
                /* 删除录音*/
                if objc is CBPetHomeRcdListModel {
                    let rcdModel = objc as! CBPetHomeRcdListModel
                    self?.homeViewModel.deleteGoHomeRecordingReuqest(voiceId: rcdModel.voiceId ?? "", id: rcdModel.id ?? "")
                }
                break
            case "add":
                /* 添加录音*/
                self?.homeViewModel.goHomeRcdUploadVoiceToQiniuRequest(msgFile: objc as! String)
                break
            case "selectRcd":
                /* 选择录音*/
                if objc is CBPetHomeRcdListModel {
                    let rcdModel = objc as! CBPetHomeRcdListModel
                    self?.homeViewModel.selectDefaultGoHomeRcdingReuqest(voiceId: rcdModel.id ?? "")
                } else if objc is String {
                /* 反选不选择*/
                    self?.homeViewModel.selectDefaultGoHomeRcdingReuqest(voiceId: "-1")
                }
                break
            case "reload":
                /* 刷新录音列表*/
                self?.recordingListView.updateRecordList(dataSource: [CBPetHomeRcdListModel]())
                break
            case "play":
                /* 播放语音*/
                CBPetChatPlayVoiceManager.share.playVoiceUrl(model: objc as! CBPetHomeRcdListModel)
                CBPetChatPlayVoiceManager.share.playTalkVoiceEndBlock = { [weak self] (objc:Any) -> Void in
                    /* 播放语音结束，设置已读 */
                    //self?.cvstionView.updateChatData(dataSource: self!.arrayDataSource)
                }
                break
            default:
                break
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
