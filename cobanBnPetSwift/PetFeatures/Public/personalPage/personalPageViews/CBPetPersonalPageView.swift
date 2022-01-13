//
//  CBPetPersonalPageView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/2.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetPersonalPageView: CBPetBaseView, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {

    private lazy var imageViewBgm:UIImageView = {
            let bgmImgV = UIImageView()
            bgmImgV.image = UIImage.init(named: "pet_login_bgm")
            bgmImgV.isUserInteractionEnabled = true
            self.addSubview(bgmImgV)
            return bgmImgV
        }()
    private lazy var bgmView:UIView = {
        let bgmV = UIView.init()
        bgmV.backgroundColor = UIColor.white
        bgmV.layer.cornerRadius = 16*KFitHeightRate
        return bgmV
    }()
    private lazy var avatarBgm:UIView = {
        let bgmImgV = UIView()
        bgmImgV.backgroundColor = UIColor.white
        bgmImgV.layer.cornerRadius = 12*KFitHeightRate
        self.addSubview(bgmImgV)
        return bgmImgV
    }()
    private lazy var avatarImageView:UIImageView = {
        let avatarImgV = UIImageView()
        avatarImgV.image = UIImage.init()
        avatarImgV.image = UIImage(named: "pet_psnal_defaultAvatar")
        avatarImgV.layer.masksToBounds = true
        avatarImgV.layer.cornerRadius = 12*KFitHeightRate
        self.addSubview(avatarImgV)
        return avatarImgV
    }()
    private lazy var nameLb:UILabel = {
        let lb = UILabel(text: "", textColor: KPetTextColor, font: UIFont(name: CBPingFangSC_Regular, size: 16*KFitHeightRate)!, textAlignment: .center)
        self.addSubview(lb)
        return lb
    }()
    private lazy var sexImageView:UIImageView = {
        let bgmImgV = UIImageView()
        bgmImgV.image = UIImage.init()
        self.addSubview(bgmImgV)
        return bgmImgV
    }()
    private lazy var noteLb:UILabel = {
        let lb = UILabel(text: "欢迎来到我的个人主页".localizedStr, textColor: KPet666666Color, font: UIFont(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!, textAlignment: .center)
        self.addSubview(lb)
        return lb
    }()
    private lazy var petTitleLb:UILabel = {
        let lb = UILabel(text: String(format: "%@%@","宠物".localizedStr ,"").localizedStr, textColor: KPet666666Color, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!, textAlignment: .left)
        self.addSubview(lb)
        return lb
    }()
    private lazy var collectionView:UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(CBPetPeronalPageCollectsCell.self, forCellWithReuseIdentifier: "CBPetPeronalPageCollectsCell")
        return collectionView
    }()
    private lazy var arrayDataSource:[Any] = {
        let arr = [Any]()
        return arr
    }()
    private lazy var arrayUserInfoDataSource:[CBPetUserInfoModel] = {
        let arr = [CBPetUserInfoModel]()
        return arr
    }()
    private lazy var personalPageTableView:UITableView = {
        let tableV:UITableView = UITableView(frame: CGRect.zero, style: .plain)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.backgroundColor = UIColor.white
        tableV.separatorStyle = .none
        tableV.register(CBPetPersonalPageTabvCell.self, forCellReuseIdentifier: "CBPetPersonalPageTabvCell")
        return tableV
    }()
    private lazy var addFriendBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton(title: "加TA宠友".localizedStr, titleColor: UIColor.white, font: UIFont(name: CBPingFangSC_Regular, size: 16*KFitHeightRate)!)
        btn.setShadow(backgroundColor: KPetAppColor, cornerRadius: 20*KFitHeightRate, shadowColor: KPetAppColor, shadowOpacity: 0.35, shadowOffset: CGSize(width: 4, height: 4), shadowRadius: 8)
        btn.isHidden = true
        return btn
    }()
    private lazy var deleteBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton(title: "删除".localizedStr, titleColor: UIColor.white, font: UIFont(name: CBPingFangSC_Regular, size: 16*KFitHeightRate)!)
        btn.setShadow(backgroundColor: KPetC8C8C8Color, cornerRadius: 20*KFitHeightRate, shadowColor: KPetC8C8C8Color, shadowOpacity: 0.35, shadowOffset: CGSize(width: 4, height: 4), shadowRadius: 8)
        btn.isHidden = true
        return btn
    }()
    private lazy var sendMsgBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton(title: "发消息".localizedStr, titleColor: UIColor.white, font: UIFont(name: CBPingFangSC_Regular, size: 16*KFitHeightRate)!)
        btn.setShadow(backgroundColor: KPetAppColor, cornerRadius: 20*KFitHeightRate, shadowColor: KPetAppColor, shadowOpacity: 0.35, shadowOffset: CGSize(width: 4, height: 4), shadowRadius: 8)
        btn.isHidden = true
        return btn
    }()
    var petFriendModel:CBPetFuncPetFriendsModel?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setupViewModel(viewModel: Any) {
        super.setupViewModel(viewModel: self.viewModel)
        self.viewModel = viewModel
        if self.viewModel is CBPetBaseViewModel {
        ///我的主页 过来，编辑资料
            let vvModel = self.viewModel as! CBPetBaseViewModel
            if vvModel.isComfromPsnalCter == true {
                self.addFriendBtn.isHidden = false
                self.addFriendBtn.setTitle("编辑资料".localizedStr, for: .normal)
                self.addFriendBtn.setTitle("编辑资料".localizedStr, for: .highlighted)
                self.addFriendBtn.removeTarget(self, action: #selector(btnClick), for: .touchUpInside)
                self.addFriendBtn.addTarget(self, action: #selector(editInformationClick), for: .touchUpInside)
            } 
            vvModel.psnalPageUpdatePetListBlock = { [weak self] (allPet:Any) -> Void in
                let allPetModel = (allPet as! CBPetPsnalCterPetAllModel)
                let petList = allPetModel.allPet
                self?.arrayDataSource = petList as [Any]
                if vvModel.isComfromPsnalCter == true {
                    var addModel = CBPetPsnalCterPetModel.init()
                    addModel.title = "添加".localizedStr
                    addModel.icon = "pet_psnal_petDefaultAvatar"
                    self?.arrayDataSource.append(addModel)
                    self?.updatePetNums(isComfromPsnalCter: true)
                } else {
                    self?.updatePetNums(isComfromPsnalCter: false)
                    if vvModel.isComfromNoticePush == true {
                        /* 推送查看资料*/
                        self?.setupHidden(isHidden: true)
                        self?.deleteBtn.setTitle("拒绝".localizedStr, for: .normal)
                        self?.sendMsgBtn.setTitle("同意宠友".localizedStr, for: .normal)
                    } else {
                        /* is_friend = 1,为好友 ， = 0 非好友  空或不存在的时候也是非好友*/
                        switch allPetModel.is_friend {
                            case "0":
                                /* 非好友*/
                                self?.setupHidden(isHidden: false)
                                break
                            case "1":
                                /* 是好友*/
                                self?.setupHidden(isHidden: true)
                                break
                            default:
                                /* 是自己*/
                                self?.addFriendBtn.isHidden = true
                                self?.deleteBtn.isHidden = true
                                self?.sendMsgBtn.isHidden = true
                                break
                        }
                    }
                }
                self?.collectionView.reloadData()
            }
            vvModel.psnalPageUpdateUserInfoBlock = { [weak self] (userInfoModelTemp:Any) -> Void in
                let userInfoModel = userInfoModelTemp as! CBPetUserInfoModel
                self?.updateUserInfo(userInfoModel:userInfoModel)
                self?.updateIsShowUserInfoPrivacy(userInfoModel: userInfoModel)
            }
        }
    }
    private func checkIsPetFriend(allPetModel:CBPetPsnalCterPetAllModel) {
        if allPetModel.allPet.count > 0 {
            let petModel = allPetModel.allPet[0]
            /* 判断是否为本人*/
            if let value = CBPetLoginModelTool.getUser()?.uid {
                if value == petModel.user.id {
                    /* 是本人*/
                    self.addFriendBtn.isHidden = true
                    self.deleteBtn.isHidden = true
                    self.sendMsgBtn.isHidden = true
                } else {
                    /* 非好友*/
                    //self.setupHidden(isHidden: false)
                    /* isAuth = 0 ，好友，其他非好友*/
                    switch petModel.isAuth {
                    case "0":
                        /* 在好友列表里,是好友*/
                        self.setupHidden(isHidden: true)
                        break
                    default:
                        /* 不在好友列表里，不是好友*/
                        self.setupHidden(isHidden: false)
                        break
                    }
                }
            } else {
                self.addFriendBtn.isHidden = true
                self.deleteBtn.isHidden = true
                self.sendMsgBtn.isHidden = true
            }
        }
    }
    private func setupHidden(isHidden:Bool) {
        self.addFriendBtn.isHidden = isHidden
        self.deleteBtn.isHidden = !isHidden
        self.sendMsgBtn.isHidden = !isHidden
    }
    //MARK: - 更新用户头部信息
    private func updateUserInfo(userInfoModel:CBPetUserInfoModel) {
        self.nameLb.text = userInfoModel.name
        self.avatarImageView.sd_setImage(with: URL.init(string: userInfoModel.photo ?? ""), placeholderImage: UIImage(named: "pet_psnal_defaultAvatar"), options: [SDWebImageOptions.refreshCached , SDWebImageOptions.lowPriority , SDWebImageOptions.retryFailed])
        if userInfoModel.sex == "0" { ///男
            self.sexImageView.image = UIImage(named: "pet_sex_male")
        } else if userInfoModel.sex == "1" {
            self.sexImageView.image = UIImage(named: "pet_sex_female")
        }
    }
    //MARK: - 更新宠物个数
    private func updatePetNums(isComfromPsnalCter:Bool) {
        if isComfromPsnalCter == true {
            guard self.arrayDataSource.count > 1 else {
                self.petTitleLb.text = String(format: "%@","宠物".localizedStr).localizedStr
                return
            }
            self.petTitleLb.text = String(format: "%@%d","宠物".localizedStr,self.arrayDataSource.count-1).localizedStr
        } else {
            guard self.arrayDataSource.count > 0 else {
                self.petTitleLb.text = String(format: "%@","宠物".localizedStr).localizedStr
                return
            }
            self.petTitleLb.text = String(format: "%@%d","宠物".localizedStr,self.arrayDataSource.count).localizedStr
        }
    }
    //MARK: - 更新用户展示的资料
    private func updateIsShowUserInfoPrivacy(userInfoModel:CBPetUserInfoModel) {
        self.arrayUserInfoDataSource.removeAll()
        let userInfoModelObject = userInfoModel
        var arrayTitle = [String]()
        var arrayText = [String]()
        if userInfoModelObject.isPublishPhone == "1" {
            arrayTitle.append("电话".localizedStr)
            arrayText.append(userInfoModelObject.phone ?? "")
        }
        if userInfoModelObject.isPublishWeixin == "1" {
            arrayTitle.append("微信".localizedStr)
            arrayText.append(userInfoModelObject.weixin ?? "")
        }
        if userInfoModelObject.isPublishEmail == "1" {
            arrayTitle.append("邮箱".localizedStr)
            arrayText.append(userInfoModelObject.email ?? "")
        }
        if userInfoModelObject.isPublishWhatsapp == "1" {
            arrayTitle.append("WhatsApp".localizedStr)
            arrayText.append(userInfoModelObject.whatsapp ?? "")
        }
        for index in 0..<arrayTitle.count {
            var model = CBPetUserInfoModel()
            model.title = arrayTitle[index]
            model.text = arrayText[index]
            self.arrayUserInfoDataSource.append(model)
        }
        self.personalPageTableView.reloadData()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    private func setupView() {
        self.addSubview(self.imageViewBgm)
        self.imageViewBgm.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0))
        }
        self.imageViewBgm.addSubview(self.bgmView)
        self.bgmView.snp_makeConstraints { (make) in
            make.left.equalTo(30*KFitWidthRate)
            make.right.equalTo(-30*KFitWidthRate)
            make.top.equalTo(120*KFitHeightRate)
            make.bottom.equalTo(-32*KFitHeightRate - TabPaddingBARHEIGHT)
        }
        
        self.bgmView.addSubview(self.avatarBgm)
        self.bgmView.addSubview(self.avatarImageView)
        self.bgmView.addSubview(self.nameLb)
        self.bgmView.addSubview(self.sexImageView)
        self.bgmView.addSubview(self.noteLb)
        self.bgmView.addSubview(self.petTitleLb)
        
        self.bgmView.addSubview(self.collectionView)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.addSubview(self.personalPageTableView)
        self.addSubview(self.addFriendBtn)
        self.addFriendBtn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        self.addSubview(self.deleteBtn)
        self.deleteBtn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        self.addSubview(self.sendMsgBtn)
        self.sendMsgBtn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        
        self.avatarBgm.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.bgmView.snp_top)
            make.centerX.equalTo(self.imageViewBgm)
            make.size.equalTo(CGSize(width: 72*KFitHeightRate, height: 72*KFitHeightRate))
        }
        self.avatarImageView.snp_makeConstraints { (make) in
            make.center.equalTo(self.avatarBgm)
            make.size.equalTo(CGSize(width: 68*KFitHeightRate, height: 68*KFitHeightRate))
        }
        self.nameLb.snp_makeConstraints { (make) in
            make.top.equalTo(self.avatarImageView.snp_bottom).offset(17*KFitHeightRate)
            make.centerX.equalTo(self.imageViewBgm)
        }
        let sexImage = UIImage(named: "pet_sex_female")!
        self.sexImageView.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.nameLb)
            make.left.equalTo(self.nameLb.snp_right).offset(8*KFitWidthRate)
            make.size.equalTo(CGSize(width: sexImage.size.width, height: sexImage.size.height))
        }
        self.noteLb.snp_makeConstraints { (make) in
            make.top.equalTo(self.nameLb.snp_bottom).offset(10*KFitHeightRate)
            make.centerX.equalTo(self.imageViewBgm)
        }
        self.petTitleLb.snp_makeConstraints { (make) in
            make.top.equalTo(self.noteLb.snp_bottom).offset(32*KFitHeightRate)
            make.left.equalTo(self.bgmView.snp_left).offset(20*KFitWidthRate)
        }
        self.collectionView.snp_makeConstraints { (make) in
            make.left.right.equalTo(self.bgmView)
            make.top.equalTo(self.petTitleLb.snp_bottom).offset(0*KFitHeightRate)
            make.height.equalTo(115*KFitHeightRate)
        }
        self.personalPageTableView.snp_makeConstraints { (make) in
            make.left.right.equalTo(self.bgmView)
            make.top.equalTo(self.collectionView.snp_bottom).offset(0)
            make.bottom.equalTo(self.bgmView.snp_bottom).offset(-70*KFitHeightRate)
        }
        self.addFriendBtn.snp_makeConstraints { (make) in
            make.left.equalTo(self.bgmView.snp_left).offset(20*KFitWidthRate)
            make.right.equalTo(self.bgmView.snp_right).offset(-20*KFitWidthRate)
            make.height.equalTo(40*KFitHeightRate)
            make.bottom.equalTo(self.bgmView.snp_bottom).offset(-28*KFitHeightRate)
        }
        self.sendMsgBtn.snp_makeConstraints { (make) in
            make.left.equalTo(self.deleteBtn.snp_right).offset(15*KFitWidthRate)
            make.right.equalTo(self.bgmView.snp_right).offset(-20*KFitWidthRate)
            make.height.equalTo(40*KFitHeightRate)
            make.bottom.equalTo(self.bgmView.snp_bottom).offset(-28*KFitHeightRate)
        }
        self.deleteBtn.snp_makeConstraints { (make) in
            make.left.equalTo(self.bgmView.snp_left).offset(20*KFitWidthRate)
            make.right.equalTo(self.sendMsgBtn.snp_left).offset(-15*KFitWidthRate)
            make.height.equalTo(40*KFitHeightRate)
            make.width.equalTo(80*KFitWidthRate)
            make.bottom.equalTo(self.bgmView.snp_bottom).offset(-28*KFitHeightRate)
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayDataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CBPetPeronalPageCollectsCell", for: indexPath) as! CBPetPeronalPageCollectsCell
        if self.arrayDataSource.count > indexPath.row {
            let petModel = self.arrayDataSource[indexPath.row]
            cell.psnalCterPetModel = petModel as! CBPetPsnalCterPetModel
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.viewModel is CBPetBaseViewModel {
            let vvModel = self.viewModel as! CBPetBaseViewModel
            if vvModel.isComfromPsnalCter {
                guard vvModel.psnalPageEditPetInfoBlock == nil else {
                    if self.arrayDataSource.count > indexPath.row {
                        let petModel = self.arrayDataSource[indexPath.row] as! CBPetPsnalCterPetModel
                        vvModel.psnalPageEditPetInfoBlock!(petModel)
                    }
                    return
                }
            } else {
                guard vvModel.psnalPageVisitPetInfoBlock == nil else {
                    if self.arrayDataSource.count > indexPath.row {
                        let petModel = self.arrayDataSource[indexPath.row] as! CBPetPsnalCterPetModel
                        vvModel.psnalPageVisitPetInfoBlock!(petModel)
                    }
                    return
                }
            }
        }
    }
    /* flowlayoutDelegate */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (SCREEN_WIDTH - 60*KFitWidthRate - 0*KFitWidthRate)/4, height: 115*KFitHeightRate)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayUserInfoDataSource.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45*KFitHeightRate
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CBPetPersonalPageTabvCell") as! CBPetPersonalPageTabvCell
        if self.arrayUserInfoDataSource.count > indexPath.row {
            let model = self.arrayUserInfoDataSource[indexPath.row]
            cell.psnalUserInfoModel = model
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //
    }
    //MARK: - 加TA宠友
    @objc private func btnClick(sender:CBPetBaseButton) {
        if self.viewModel is CBPetBaseViewModel {
            let vvModel = self.viewModel as! CBPetBaseViewModel
            switch sender {
            case self.addFriendBtn:
                CBLog(message: "加TA宠友 加TA宠友 加TA宠友")
                guard (self.viewModel as! CBPetBaseViewModel).psnalPageActionBlock == nil else {
                    (self.viewModel as! CBPetBaseViewModel).psnalPageActionBlock!(2020)
                    return
                }
                break
            case self.deleteBtn:
                CBLog(message: "删除")
                if vvModel.isComfromNoticePush == true {
                    guard (self.viewModel as! CBPetBaseViewModel).psnalPageActionBlock == nil else {
                        (self.viewModel as! CBPetBaseViewModel).psnalPageActionBlock!(2023)
                        return
                    }
                } else {
                    guard (self.viewModel as! CBPetBaseViewModel).psnalPageActionBlock == nil else {
                        (self.viewModel as! CBPetBaseViewModel).psnalPageActionBlock!(2021)
                        return
                    }
                }
                break
            case self.sendMsgBtn:
                CBLog(message: "发消息")
                if vvModel.isComfromNoticePush == true {
                    guard (self.viewModel as! CBPetBaseViewModel).psnalPageActionBlock == nil else {
                        (self.viewModel as! CBPetBaseViewModel).psnalPageActionBlock!(2024)
                        return
                    }
                } else {
                    guard (self.viewModel as! CBPetBaseViewModel).psnalPageActionBlock == nil else {
                        (self.viewModel as! CBPetBaseViewModel).psnalPageActionBlock!(2022)
                        return
                    }
                }
                break
            default:
                break
            }
        }
    }
    //MARK: - 编辑资料
    @objc private func editInformationClick() {
        if self.viewModel is CBPetBaseViewModel {
            guard (self.viewModel as! CBPetBaseViewModel).psnalPageEditUserInfoBlock == nil else {
                (self.viewModel as! CBPetBaseViewModel).psnalPageEditUserInfoBlock!("")
                return
            }
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
