//
//  CBPetTimeReportPickTime.swift
//  cobanBnPetSwift
//
//  Created by hsl on 2021/12/19.
//  Copyright © 2021 coban. All rights reserved.
//

import UIKit

class CBPetTimeReportPickTime: CBPetBaseView,UIPickerViewDelegate,UIPickerViewDataSource,UIGestureRecognizerDelegate {

    private lazy var bgmView:UIView = {
        let bgmV = UIView.init()
        bgmV.backgroundColor = UIColor.white
        bgmV.layer.masksToBounds = true
        bgmV.layer.cornerRadius = 16*KFitHeightRate
        return bgmV
    }()
    private lazy var titleLb:UILabel = {
        let lb = UILabel(text: "添加唤醒时间".localizedStr, textColor: KPetTextColor, font: UIFont(name: CBPingFang_SC, size: 14*KFitHeightRate)!, textAlignment: .center)
        return lb
    }()
    private lazy var closeBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton(title: "".localizedStr, titleColor: KPetAppColor, font: UIFont(name: CBPingFang_SC, size: 12*KFitHeightRate)!)
        btn.setImage(UIImage(named: "pet_function_shout_cancel"), for: .normal)
        btn.addTarget(self, action: #selector(dissmiss), for: .touchUpInside)
        self.bgmView.addSubview(btn)
        return btn
    }()
    private lazy var comfirmBtn:UIButton = {
        let btn = UIButton(title: "".localizedStr, titleColor: KPetAppColor, font: UIFont(name: CBPingFang_SC, size: 14*KFitHeightRate)!)
        btn.setImage(UIImage(named: "pet_function_shout_comfirm"), for: .normal)
        btn.addTarget(self, action: #selector(comfirmClick), for: .touchUpInside)
        self.bgmView.addSubview(btn)
        return btn
    }()
    
    private lazy var cornerView:UIView = {
        let bgmV = UIView.init()
        bgmV.backgroundColor = UIColor(red: 233/255.0, green: 239/255, blue: 234/255, alpha: 1.0)
        bgmV.layer.masksToBounds = true
        bgmV.layer.cornerRadius = 6*KFitHeightRate
        self.bgmView.addSubview(bgmV)
        return bgmV
    }()
    private lazy var hourPickerView:UIPickerView = {
        let pick = UIPickerView.init()
        pick.dataSource = self
        pick.delegate = self
        self.cornerView.addSubview(pick)
        return pick
    }()
    private lazy var minutePickerView:UIPickerView = {
        let pick = UIPickerView.init()
        pick.dataSource = self
        pick.delegate = self
        self.cornerView.addSubview(pick)
        return pick
    }()
    private lazy var middleLb:UILabel = {
        let lb = UILabel(text: ":", textColor: KPetAppColor, font: UIFont(name: CBPingFangSC_Regular, size: 16)!, textAlignment: .center)
        self.addSubview(lb)
        return lb
    }()
    private lazy var pickerLb:UILabel = {
        let lb = UILabel(text: "", textColor: KPetAppColor, font: UIFont(name: CBPingFangSC_Regular, size: 16)!, textAlignment: .center)
        return lb
    }()
    private lazy var markLb:UILabel = {
        let lb = UILabel(text: ":", textColor: KPetAppColor, font: UIFont(name: CBPingFangSC_Regular, size: 16)!, textAlignment: .center)
        self.cornerView.addSubview(lb)
        return lb
    }()
    private lazy var arrayDataHour:[Any] = {
        let arr = Array<Any>()
        return arr
    }()
    private lazy var arrayDataMinute:[Any] = {
        let arr = Array<Any>()
        return arr
    }()
    private var hour = ""
    private var minute = ""
    
    var retrunBlock:((_ hour:String,_ minute:String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setupViewModel(viewModel: Any) {
        self.viewModel = viewModel
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    convenience init(width_par:CGFloat,height_par:CGFloat) {
        self.init()
//        width = width_par
//        height = height_par
        setupView()
    }
    private func setupView() {
        self.backgroundColor = UIColor.init().colorWithHexString(hexString: "#222222", alpha: 0.85)
        
//        let tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapGestureMethod))
//        //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
//        tapGestureRecognizer.cancelsTouchesInView = false;
//        tapGestureRecognizer.delegate = self;
//        //将触摸事件添加到当前view
//        self.addGestureRecognizer(tapGestureRecognizer)
        
        self.addSubview(self.bgmView)
        self.bgmView.snp_makeConstraints { (make) in
            make.center.equalTo(self)
            make.size.equalTo(CGSize(width: 200, height: 20 + 20 + 70 + 20 + 40 + 30))
        }
        
        self.addSubview(self.titleLb)
        self.titleLb.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.bgmView.snp_centerX)
            make.top.equalTo(self.bgmView.snp_top).offset(15*KFitHeightRate)
            make.left.equalTo(self.bgmView.snp_left).offset(10*KFitWidthRate)
            make.right.equalTo(self.bgmView.snp_right).offset(-10*KFitWidthRate)
        }
        

        
        self.cornerView.snp.makeConstraints { make in
            make.top.equalTo(titleLb.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 120, height: 70))
        }
        
        self.hourPickerView.snp_makeConstraints { (make) in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 60,height: 100))
        }
        self.minutePickerView.snp_makeConstraints { (make) in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 60,height: 100))
        }
        
        self.closeBtn.snp_makeConstraints { (make) in
            make.left.equalTo(cornerView)
            make.top.equalTo(cornerView.snp.bottom).offset(20)
        }
        self.comfirmBtn.snp_makeConstraints { (make) in
            make.right.equalTo(cornerView)
            make.top.equalTo(cornerView.snp.bottom).offset(20)
        }
        self.markLb.snp_makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        for index in 0..<60 {
            if index <= 23 {
                self.arrayDataHour.append(String.init(format: "%02d", index))
            }
            self.arrayDataMinute.append(String.init(format: "%02d", index))
        }
        
    }
    @objc private func tapGestureMethod(tap:UITapGestureRecognizer) {
        self.dissmiss()
    }
//    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        /* 判断该区域是否包含某个指定的区域 */
//        if self.bgmView.frame.contains(gestureRecognizer.location(in: self)) {
////            if (self.recordButton.frame.contains(gestureRecognizer.location(in: self.recordView)) && self.recordButton.isHidden == false) {
////                return true
////            }
//            return false
//        }
//        return true
//    }
    public func popView() {
        UIApplication.shared.keyWindow?.addSubview(self)
        hourPickerView.reloadAllComponents()
        minutePickerView.reloadAllComponents()
    }
    @objc private func dissmiss() {
        self.removeFromSuperview()
    }
    @objc private func comfirmClick() {
        if self.retrunBlock != nil {
            self.retrunBlock!(hour, minute)
        }
        self.dissmiss()
    }

    //MARK: - 执行UIPickViewDataSource协议
    //设置选择框的总列数,继承于UIPickViewDataSource协议
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        print("numberOfComponents")
        return 1
    }
    
    //设置选择框的总行数,继承于UIPickViewDataSource协议
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        print("pickerView:numberOfRowsInComponent:")
        if pickerView == hourPickerView {
            return self.arrayDataHour.count
        } else {
            return self.arrayDataMinute.count
        }
    }
    
    //MARK: - 执行UIPickViewDelegate协议
    // 设置选项框各选项的内容
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        print("pickerView:titleForRow:forComponent:")
//        if(component == 0) { //选择第一级数据
//            // 记录用户选择的值
////            let selectedProvince = self.pickerProvincesData[row] as String
////            // 根据第一列选择的值，更新第二列数据
////            self.pickerCitiesData = self.pickerData[selectedProvince]!
////
////            return self.pickerProvincesData[row]
//            return self.arrayDataHour[row] as? String
//        }else {//选择第二级数据
//            //return self.pickerCitiesData[row]
//
//            return self.arrayDataMinute[row] as? String
//        }
        if pickerView == hourPickerView {
            return self.arrayDataHour[row] as? String
        } else {
            return self.arrayDataMinute[row] as? String
        }

    }
    // 选择pickerView的某个拨轮中的某行时调用
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("pickerView:didSelectRow:inComponent:")
        if pickerView == hourPickerView {
            hour = self.arrayDataHour[row] as! String
        } else {
            minute = self.arrayDataMinute[row] as! String
        }
    }
    
    // 设置每行选项的高度
//    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
//        return 15.0*1 + 45
//    }
//    // 设置每行选项的宽度
//    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
//        return 20.0
//    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        /*重新定义row 的UILabel*/
        self.pickerLb = view as? UILabel ?? UILabel.init()
        pickerLb.backgroundColor = UIColor.clear
        pickerLb.textAlignment = .center
        self.pickerLb.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
//        if pickerView == hourPickerView {
//            hour = self.arrayDataHour[row] as! String
//        } else {
//            minute = self.arrayDataMinute[row] as! String
//        }
        return self.pickerLb
    }
//    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
//
//        var titleStr = "66"
//        if component == 0 {
//            titleStr = self.pickerProvincesData[row]
//        } else if component == 1 {
//            titleStr = self.pickerProvincesData[row]
//        }
//
//        let attribute = NSMutableAttributedString.init(string: titleStr)
//        //return ""
//        return attribute
//    }
}
