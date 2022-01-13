//
//  CBPetSelectTimeZViewController.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/6.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetSelectTimeZViewController: CBPetBaseViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    public lazy var homeViewModel:CBPetHomeViewModel = {
        let viewMd = CBPetHomeViewModel.init()
        return viewMd
    }()
    private lazy var collectionView:UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.scrollDirection = .vertical
        let collectionView = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT), collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CBPetSelectTimeZCell.self, forCellWithReuseIdentifier: "CBPetSelectTimeZCell")
        return collectionView
    }()
    private lazy var arrayDataSource:[String] = {
        var arr = [String]()
        var kk = 12.0
        for index in 0...48 {
            if kk > 0.0 {
                arr.append("+\(kk.cleanZero)")
            } else {
                arr.append("\(kk.cleanZero)")
            }
            kk = kk - 0.5
        }
        return arr
    }()
    private var selectBtn:CBPetBaseButton?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupView()
        updateDataSource()
    }
    private func setupView() {
        self.view.backgroundColor = .white
        initBarWith(title: "请选择时区".localizedStr, isBack: true)
        initBarRight(title: "确定".localizedStr, action: #selector(setTimeZoneRequest))
        self.rightBtn.setTitleColor(KPetAppColor, for: .normal)
        self.rightBtn.setTitleColor(KPetAppColor, for: .highlighted)
        self.rightBtn.titleLabel?.font = UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)
        
        self.view.addSubview(self.collectionView)
        self.collectionView.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(self.view)
            make.left.equalTo(20*KFitWidthRate)
            make.right.equalTo(-20*KFitWidthRate)
        }
    }
    // MARK: - 数据源刷新
    private func updateDataSource() {
        self.homeViewModel.petHomeSetTimeZoneBlock = { [weak self] (objc:Any) -> Void in
            MBProgressHUD.showMessage(Msg: "设置成功".localizedStr, Deleay: 1.5)
            self?.navigationController?.popViewController(animated: true)
        }
    }
    //MARK: - 选择时区确定
    @objc private func setTimeZoneRequest() {
        guard self.selectBtn != nil else {
            MBProgressHUD.showMessage(Msg: "请选择时区".localizedStr, Deleay: 1.5)
            return
        }
        self.homeViewModel.setTimeZoneReuqest(time_zoneStr:self.selectBtn?.titleLabel?.text ?? "2020")
    }
    @objc private func comfirmMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayDataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CBPetSelectTimeZCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CBPetSelectTimeZCell", for: indexPath) as! CBPetSelectTimeZCell
        if indexPath.row == 0 {
            ///给个初始实例
            self.selectBtn = cell.textBtn
        }
        if self.arrayDataSource.count > indexPath.row {
            cell.clickReturnBlock = { [weak self] (sender:CBPetBaseButton) -> Void in
                self?.btnClick(sender: sender)
            }
            cell.textBtn.setTitle(self.arrayDataSource[indexPath.row], for: .normal)
            if Float(self.arrayDataSource[indexPath.row]) == Float(self.homeViewModel.paramtersObject?.timeZone ?? "2020") {
                self.selectBtn = cell.textBtn
                self.btnClick(sender: self.selectBtn!)
            } else {
                ///设置上次选中的属性 为不选中
                cell.textBtn.backgroundColor = UIColor.white
                cell.textBtn.setTitleColor(KPet666666Color, for: .normal)
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    /* flowlayoutDelegate */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (SCREEN_WIDTH - 15*KFitWidthRate*4 - 40*KFitWidthRate)/5, height: 40*KFitHeightRate)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        ///段距
        return UIEdgeInsets.init(top: 5*KFitHeightRate, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        ///行距
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        ///单元格间距
        return 15*KFitWidthRate
    }
    private func btnClick(sender:CBPetBaseButton) {
        if sender == self.selectBtn {
            ///恰好当前选中 等于 初始实例, 就只设置当前
            sender.backgroundColor = KPetAppColor
            sender.setTitleColor(UIColor.white, for: .normal)
        } else {
            /// 选中新的实例，并设置它的选中属性
            sender.backgroundColor = KPetAppColor
            sender.setTitleColor(UIColor.white, for: .normal)
            ///设置上次选中的属性 为不选中
            self.selectBtn!.backgroundColor = UIColor.white
            self.selectBtn!.setTitleColor(KPet666666Color, for: .normal)
        }
        ///记录选中的实例
        self.selectBtn = sender
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
