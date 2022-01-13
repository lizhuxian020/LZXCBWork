//
//  CBPetPopSheetView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/9.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetPopSheetView: CBPetBaseView,UITableViewDelegate, UITableViewDataSource {

    /// 点击完成按钮的回调
    private var clickComfirmBtnBlock:((_ title:String,_ Index:Int) -> Void)?
    /// 点击取消的回调
    //private var clickCancelBtnBlock:((_ title:String,_ Index:Int) -> Void)?
    ///单例
    static let share:CBPetPopSheetView = {
        let view = CBPetPopSheetView.init()
        return view
    }()
    ///背景view
    private lazy var bgView:CBPetBaseView = {
        let bgmV = CBPetBaseView()
        return bgmV
    }()
    private lazy var sheetTableView:UITableView = {
        let tableV:UITableView = UITableView(frame: CGRect.zero, style: .plain)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.backgroundColor = UIColor.white
        tableV.separatorStyle = .none
        tableV.estimatedRowHeight = 44*KFitHeightRate
        tableV.rowHeight = UITableView.automaticDimension
        tableV.register(CBPetPopSheetTabCell.self, forCellReuseIdentifier: "CBPetPopSheetTabCell")
        return tableV
    }()
    private lazy var dataSourceArray:[String] = {
        let arr = [String]()
        return arr
    }()
    private var selectBtn:CBPetBaseButton?
    public var selectIndex:Int = 0
    public var isAllowSelect:Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupBgmView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        /// 防止y超过屏幕
        if self.bgView.frame.size.height >= SCREEN_HEIGHT {
            self.bgView.snp_updateConstraints { (make) in
                make.left.right.bottom.equalTo(self)
                make.size.equalTo(CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT - NavigationBarHeigt - TabPaddingBARHEIGHT))
            }
            self.sheetTableView.snp_updateConstraints { (make) in
                make.left.right.top.equalTo(self.bgView)
                make.bottom.equalTo(self.bgView.snp_bottom).offset(-TabPaddingBARHEIGHT)
                make.height.equalTo(SCREEN_HEIGHT - NavigationBarHeigt - TabPaddingBARHEIGHT)
            }
        } else {
            if self.sheetTableView.contentSize.height+10*KFitHeightRate+TabPaddingBARHEIGHT > SCREEN_HEIGHT {
                self.bgView.snp_updateConstraints { (make) in
                    make.left.right.bottom.equalTo(self)
                    make.size.equalTo(CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT - NavigationBarHeigt - TabPaddingBARHEIGHT))
                }
            } else {
                self.bgView.snp_updateConstraints { (make) in
                    make.left.right.bottom.equalTo(self)
                    if self.dataSourceArray.count > 2 {
                        make.size.equalTo(CGSize(width: SCREEN_WIDTH, height: self.sheetTableView.contentSize.height+10*KFitHeightRate+TabPaddingBARHEIGHT))
                    } else {
                        make.size.equalTo(CGSize(width: SCREEN_WIDTH, height: self.sheetTableView.contentSize.height+0*KFitHeightRate+TabPaddingBARHEIGHT))
                    }
                }
            }
        }
    }
    //点击背景view 移除当前控件
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first  {
            var point =  touch.location(in: self)
            point = bgView.layer.convert(point, from: self.layer)
            if !bgView.layer.contains(point){
                self.removeView()
            }
        }
    }
    //MARK: - 设置view
    private func setupBgmView() {
        self.backgroundColor = UIColor.init().colorWithHexString(hexString: "#222222", alpha: 0.85)
        self.frame = UIScreen.main.bounds
        /// 马上刷新界面  ///self.layoutIfNeeded() ///强制刷新布局 ///setNeedsLayout
        self.addSubview(self.bgView)
        self.bgView.snp_makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.size.equalTo(CGSize(width: SCREEN_WIDTH, height: 0))
        }
    }
    private func setupSheetView() {
        self.bgView.addSubview(self.sheetTableView)
        self.sheetTableView.snp_makeConstraints { (make) in
            make.left.right.top.equalTo(self.bgView)
            make.bottom.equalTo(self.bgView.snp_bottom).offset(-TabPaddingBARHEIGHT)
            make.height.equalTo(self.sheetTableView.contentSize.height)
        }
    }
    /// 带标题显示弹框
    public func showAlert(dataSource:[String],completeBtnBlock:((_ title:String,_ Index:Int) -> Void)?) {
        UIApplication.shared.keyWindow!.subviews.forEach { (vv) in
           if vv is CBPetPopSheetView {
               return
           }
        }
        self.setupSheetView()
        self.dataSourceArray = dataSource
        if self.dataSourceArray.count == 0 { return CBLog(message: "请添加数据源/Users/huangshengli/Desktop/cobanPet_swift/cobanBnPetSwift.xcodeproj[String],eg:['5','10','15'...]") }
        
        UIApplication.shared.keyWindow!.addSubview(self)
        self.clickComfirmBtnBlock = completeBtnBlock
        self.alpha = 0
        self.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3) {
           self.alpha = 1
           self.isUserInteractionEnabled = true
        }
        self.sheetTableView.reloadData()
    }
    //MARK: - 移除弹框(内部移除)
    /// 移除弹框(内部移除)
    private func removeView() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.alpha = 0
        }) { [weak self] (res) in
            self?.removeFromSuperview()
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSourceArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CBPetPopSheetTabCell") as! CBPetPopSheetTabCell
        if indexPath.row == self.selectIndex {
            ///给个初始实例
            self.selectBtn = cell.textBtn
        }
        if self.dataSourceArray.count > indexPath.row {
            cell.clickReturnBlock = { [weak self] (sender:CBPetBaseButton,index:Int) -> Void in
                self?.btnClick(sender: sender,index: index)
            }
            cell.textBtn.setTitle(self.dataSourceArray[indexPath.row], for: .normal)
            cell.textBtn.setTitle(self.dataSourceArray[indexPath.row], for: .highlighted)
            cell.textBtn.setTitleColor(KPet666666Color, for: .normal)
            cell.textBtn.setTitleColor(KPet666666Color, for: .highlighted)
            if (self.selectBtn != nil) {
                self.selectBtn!.setTitleColor(KPetAppColor, for: .normal)
            }
            cell.cellIndexPath = indexPath
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    private func btnClick(sender:CBPetBaseButton,index:Int) {
        if self.isAllowSelect == true {
            if sender == self.selectBtn {
                ///恰好当前选中 等于 初始实例, 就只设置当前
                sender.setTitleColor(KPetAppColor, for: .normal)
            } else {
                /// 选中新的实例，并设置它的选中属性
                sender.setTitleColor(KPetAppColor, for: .normal)
                ///设置上次选中的属性 为不选中
                self.selectBtn!.setTitleColor(KPet666666Color, for: .normal)
            }
            ///记录选中的实例
            self.selectBtn = sender
        }
        clickComfirmBtnBlock?(sender.titleLabel!.text!,index)
        self.removeView()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
extension CBPetPopSheetView {
//    @objc private func clickComfirmBtn() {
//        clickComfirmBtnBlock?()
//        self.removeView()
//    }
//    @objc private func clickCancelBtn() {
//        clickCancelBtnBlock?(true)
//        self.removeView()
//    }
}
class CBPetPopSheetTabCell: CBPetBaseTableViewCell {

    private lazy var lineView:UIView = {
        let view = UIView.init()
        view.backgroundColor = KPetBgmColor
        return view
    }()
    public lazy var textBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton(title: "MM", titleColor: KPet666666Color, font: UIFont(name: CBPingFangSC_Regular, size: 16*KFitHeightRate)!)
        btn.backgroundColor = UIColor.white
        return btn
    }()
    var clickReturnBlock:((_ sender:CBPetBaseButton,_ index:Int) ->Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    private func setupView() {
        self.selectionStyle = .none
        self.backgroundColor = KPetBgmColor//UIColor.white
    
        self.addSubview(self.lineView)
        self.addSubview(self.textBtn)
        self.lineView.snp_makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(10*KFitHeightRate)
        }
        self.textBtn.snp_makeConstraints { (make) in
            make.top.equalTo(self.lineView.snp_bottom).offset(0)
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(44*KFitHeightRate)
        }
        self.textBtn.addTarget(self, action: #selector(btnClickMethod), for: .touchUpInside)
    }
    @objc private func btnClickMethod(sender:CBPetBaseButton) {
        guard self.clickReturnBlock == nil else {
            self.clickReturnBlock!(sender,self.cellIndexPath.row)
            return
        }
    }
    var cellIndexPath:IndexPath = IndexPath() {
        didSet {
            if cellIndexPath.row == 0 {
                self.lineView.snp_updateConstraints { (make) in
                    make.top.left.right.equalTo(0)
                    make.height.equalTo(0*KFitHeightRate)
                }
            } else {
                self.lineView.snp_updateConstraints { (make) in
                    make.top.left.right.equalTo(0)
                    make.height.equalTo(10*KFitHeightRate)
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
