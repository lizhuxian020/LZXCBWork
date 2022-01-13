//
//  CBPetFuncChatMainView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/5/30.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetFuncScrollView:UIScrollView,UIGestureRecognizerDelegate,UIScrollViewDelegate {
    /* 允许接收多个手势 */
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        //let scrollVV = gestureRecognizer.view as! UIScrollView
        if gestureRecognizer.state != .possible {
            //&& (scrollVV.contentOffset.x >= SCREEN_WIDTH && scrollVV.contentOffset.x <= SCREEN_WIDTH+10)
            return true
        } else {
            return false
        }
    }
}

private let lineWidth = 44*KFitWidthRate
private let buttonHeight = 52*KFitHeightRate

class CBPetFuncChatMainView: CBPetBaseView, UIScrollViewDelegate {

    private lazy var mainScrollView:CBPetFuncScrollView = {
        let scrollV = CBPetFuncScrollView.init()
        scrollV.delegate = self
        scrollV.isPagingEnabled = true
        scrollV.backgroundColor = UIColor.white
        scrollV.showsHorizontalScrollIndicator = false
        //scrollV.isScrollEnabled = false
        return scrollV
    }()
    private lazy var nearByPetsView:CBPetChatNearbyPetsView = {
        let vv = CBPetChatNearbyPetsView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH-40*KFitWidthRate, height: SCREEN_HEIGHT))
        return vv
    }()
    private lazy var petfriendView:CBPetChatPetfriendView = {
        let vv = CBPetChatPetfriendView.init(frame: CGRect(x: SCREEN_WIDTH, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        return vv
    }()
    private lazy var petmessageView:CBPetChatPetmessageView = {
        let vv = CBPetChatPetmessageView.init(frame: CGRect(x: SCREEN_WIDTH*2, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        return vv
    }()
    private lazy var shadowBgmView:UIView = {
        let bgmV = UIView(backgroundColor: UIColor.white, cornerRadius: 16*KFitHeightRate, shadowColor: KPetC8C8C8Color, shadowOpacity: 0.85, shadowOffset: CGSize(width: 4, height: 0), shadowRadius: 8)
        return bgmV
    }()
    private lazy var bgmView:UIView = {
        let bgmV = UIView.init()
        bgmV.backgroundColor = UIColor.white
        return bgmV
    }()
    private lazy var lineView:UIView = {
        let line = CBPetUtilsCreate.createLineView()
        line.backgroundColor = KPetAppColor
        line.layer.cornerRadius = 1*KFitHeightRate
        return line
    }()
    private lazy var arrayBtn:[UIButton] = {
        let arr = [UIButton]()
        return arr
    }()
    private var selectBtn:CBPetBaseButton?
    private lazy var arrayBtnTitle:[String] = {
        let arr = ["附近宠物".localizedStr,"宠友列表".localizedStr,"宠友消息".localizedStr]
        return arr
    }()
    private lazy var btnWidth:CGFloat = 0.0
    
    private lazy var arrayPetFriendsList:[Any] = {
        let arr = Array<Any>()
        return arr
    }()
    private lazy var arrayPetFriendsMsgList:[Any] = {
        let arr = Array<Any>()
        return arr
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.mainScrollView.contentSize = CGSize(width: SCREEN_WIDTH*3, height: 0)
        
        let maskPath = UIBezierPath.init(roundedRect: self.bgmView.bounds, byRoundingCorners: UIRectCorner(rawValue: UIRectCorner.bottomLeft.rawValue | UIRectCorner.bottomRight.rawValue), cornerRadii: CGSize(width: 16*KFitHeightRate, height: 16*KFitHeightRate))
        let maskLayer = CAShapeLayer.init()
        /* 设置大小*/
        maskLayer.frame = self.bgmView.bounds
        /* 设置图形样子*/
        maskLayer.path = maskPath.cgPath
        self.bgmView.layer.mask = maskLayer
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setupViewModel(viewModel: Any) {
        self.viewModel = viewModel

        self.nearByPetsView.setupViewModel(viewModel: self.viewModel)
        self.petfriendView.setupViewModel(viewModel: self.viewModel)
        if self.viewModel is CBPetFuncChatViewModel {
            let vvModel = self.viewModel as! CBPetFuncChatViewModel
            vvModel.petFriendsApplyListUpdUIBlock = { [weak self] (isEnd:Bool,dataSource:[Any]) -> Void in
                if isEnd == true {
                    self?.petfriendView.endRefresh(dataSourceApply: dataSource[0] as! [CBPetFuncPetFriendsModel],dataSource: dataSource[1] as! [CBPetFuncPetFriendsModel])
                } else {
                    if dataSource.count <= 0 {
                        self?.petfriendView.beginRefresh()
                    }
                }
            }
            vvModel.petFriendsListUpdUIBlock = { [weak self] (isEnd:Bool,dataSource:[Any]) -> Void in
                self?.arrayPetFriendsList = dataSource
                if isEnd == true {
                    self?.petfriendView.endRefresh(dataSourceApply: dataSource[0] as! [CBPetFuncPetFriendsModel],dataSource: dataSource[1] as! [CBPetFuncPetFriendsModel])
                } else {
                    if dataSource.count <= 0 {
                        self?.petfriendView.beginRefresh()
                    }
                }
            }
            vvModel.petFriendsMsgListUpdUIBlock = { [weak self] (isEnd:Bool,dataSource:[Any]) -> Void in
                self?.arrayPetFriendsMsgList = dataSource
                if isEnd == true {
                    self?.petmessageView.endRefresh(dataSource: dataSource as! [CBPetFuncPetFriendsMsgModel])
                } else {
                    if dataSource.count <= 0 {
                        self?.petmessageView.beginRefresh()
                    }
                }
            }
            //self.menuBtnClick(sender: self.arrayBtn[vvModel.defaultIndex] as! CBPetBaseButton)
        }
        self.petmessageView.setupViewModel(viewModel: self.viewModel)
    }
    private func setupView() {
        self.backgroundColor = UIColor.white

        self.addSubview(self.mainScrollView)
        self.mainScrollView.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        NotificationCenter.default.addObserver(self, selector: #selector(notificationMethodScrollEable), name: NSNotification.Name(rawValue: K_CBPetFuncChatScrollEnable), object: nil)
        
        self.addSubview(self.shadowBgmView)
        self.shadowBgmView.snp_makeConstraints { (make) in
            make.top.equalTo(10*KFitHeightRate)
            make.left.equalTo(0)
            make.size.equalTo(CGSize(width: SCREEN_WIDTH, height: 42*KFitHeightRate))
        }
        self.addSubview(self.bgmView)
        self.bgmView.snp_makeConstraints { (make) in
            make.left.top.right.equalTo(self)
            make.size.equalTo(CGSize(width: SCREEN_WIDTH, height: 52*KFitHeightRate))
        }
        
        self.arrayBtn.removeAll()
        self.btnWidth = SCREEN_WIDTH/CGFloat(self.arrayBtnTitle.count)
        
        for index in 0..<self.arrayBtnTitle.count {
            let btn = CBPetBaseButton(title: self.arrayBtnTitle[index], titleColor: KPet666666Color, font: UIFont(name: CBPingFangSC_Regular, size: 16*KFitHeightRate)!)
            btn.frame = CGRect(x: self.btnWidth*CGFloat(index), y: 0, width: self.btnWidth, height: buttonHeight)
            if index == 0 {
                btn.isSelected = true
                self.selectBtn = btn
                let titleStr = self.arrayBtnTitle[index]
                let titleWidth = titleStr.getWidthText(text: titleStr, font: UIFont(name: CBPingFangSC_Regular, size: 16*KFitHeightRate)!, height: 52*KFitHeightRate)
                self.lineView.frame = CGRect(x: self.btnWidth*CGFloat(index) + (self.btnWidth - titleWidth)/2 + (titleWidth-lineWidth)/2, y: buttonHeight-3*KFitHeightRate, width: lineWidth, height: 3*KFitHeightRate)
                self.bgmView.addSubview(self.lineView)
            }
            btn.tag = 2020 + index
            btn.setTitleColor(KPetAppColor, for: .selected)
            btn.addTarget(self, action: #selector(menuBtnClick), for: .touchUpInside)
            self.arrayBtn.append(btn)
            self.bgmView.addSubview(btn)
        }
        self.bgmView.addSubview(self.lineView)
        
        self.mainScrollView.addSubview(self.nearByPetsView)
        self.mainScrollView.addSubview(self.petfriendView)
        self.mainScrollView.addSubview(self.petmessageView)
    }
    func updateIndex(index:Int) {
        let sender = self.arrayBtn[index]
        if self.selectBtn == sender {
            return
        }
        self.selectBtn?.isSelected = false
        sender.isSelected = true
        self.selectBtn = sender as? CBPetBaseButton
        
        self.mainScrollView.setContentOffset(CGPoint(x: index*Int(SCREEN_WIDTH), y: 0), animated: false)
        let titleStr = self.arrayBtnTitle[index]
        let titleWidth = titleStr.getWidthText(text: titleStr, font: UIFont(name: CBPingFangSC_Regular, size: 16*KFitHeightRate)!, height: 52*KFitHeightRate)
        self.lineView.frame = CGRect(x: self.btnWidth*CGFloat(index) + (self.btnWidth - titleWidth)/2 + (titleWidth-lineWidth)/2, y: buttonHeight-3*KFitHeightRate, width: lineWidth, height: 3*KFitHeightRate)
    }

    @objc private func menuBtnClick(sender:CBPetBaseButton) {
        if self.selectBtn == sender {
            return
        }
        self.selectBtn?.isSelected = false
        sender.isSelected = true
        self.selectBtn = sender
        
        let titleStr = self.arrayBtnTitle[sender.tag - 2020]
        let titleWidth = titleStr.getWidthText(text: titleStr, font: UIFont(name: CBPingFangSC_Regular, size: 16*KFitHeightRate)!, height: buttonHeight)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.lineView.frame = CGRect(x: self.btnWidth*CGFloat(sender.tag - 2020) + (self.btnWidth - titleWidth)/2 + (titleWidth-lineWidth)/2, y: buttonHeight - 3*KFitHeightRate, width: lineWidth, height: 3*KFitHeightRate)
        })
        self.mainScrollView.setContentOffset(CGPoint(x: (sender.tag - 2020)*Int(SCREEN_WIDTH), y: 0), animated: false)
        
//        self.petfriendView.endRefresh(dataSourceApply: self.arrayPetFriendsList[0] as! [CBPetFuncPetFriendsModel],dataSource: self.arrayPetFriendsList[1] as! [CBPetFuncPetFriendsModel])
//        self.petmessageView.endRefresh(dataSource: self.arrayPetFriendsMsgList as! [CBPetFuncPetFriendsMsgModel])
        
        ///点击菜单使UISrollView 滚动
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: K_CBPetFuncChatScrollEnable), object: ["scrollEable":true])
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollView 滑动...\(scrollView.contentOffset)...")
        /// 滑动条跟随一起滑动
        let xx = scrollView.contentOffset.x/CGFloat(self.arrayBtnTitle.count) + (self.btnWidth - lineWidth)/2.0
        self.lineView.frame = CGRect(x: xx, y: buttonHeight-3*KFitHeightRate, width: lineWidth, height: 3*KFitHeightRate)
        
        if scrollView.contentOffset.x == SCREEN_WIDTH || scrollView.contentOffset.x == SCREEN_WIDTH*2 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: K_CBPetFuncChatTableViewEnableFalse), object: ["scrollEable":true])
        } else {
            /// 设置宠友列表 tableView 不能滑动
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: K_CBPetFuncChatTableViewEnableFalse), object: ["scrollEable":false])
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let index = NSInteger(offsetX / SCREEN_WIDTH)
        CBLog(message: "滑动 滑动 第\(index) 页")
        let btn = self.arrayBtn[index]
        self.menuBtnClick(sender: btn as! CBPetBaseButton)
    }
    
    @objc private func notificationMethodScrollEable(notifi:Notification) {
        let resultDic:[String:Any] = notifi.object as! [String : Any]
        let result = resultDic["scrollEable"]
        if (result as! Bool) == true {
            self.mainScrollView.isScrollEnabled = true
        } else {
            self.mainScrollView.isScrollEnabled = false
        }
    }
    deinit {
        /// 移除通知
        NotificationCenter.default.removeObserver(self)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
