//
//  CBPetCustomSlideView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/6.
//  Copyright © 2020 coban. All rights reserved.
//
//    private var sliderView:CBPetCustomSlider = {
//        //创建Slider
//        let slider = CBPetCustomSlider.init(frame: CGRect(x: 24*KFitWidthRate, y: 0, width: 270*KFitWidthRate - 24*2*KFitWidthRate, height: 35*KFitHeightRate))
//        slider.backgroundColor = UIColor.white
//        //最小值
//        slider.minimumValue = 0
//        //最大值
//        slider.maximumValue = 30
//        //设置默认值
//        slider.value = 0.0
//        //设置Slider值，并有动画效果
//        slider.setValue(0.0, animated: true)
//        //设置Slider两边槽的颜色
//        slider.minimumTrackTintColor = KPetAppColor//UIColor.red
//        slider.maximumTrackTintColor = KPetLineColor
//        //添加两边槽图片
//        //slider.minimumValueImage = UIImage(named: "pet_func_listen_slide")
//        //slider.maximumValueImage = UIImage(named: "pet_func_listen_slide")
//        //设置Slider组件图片
//        //slider.setMaximumTrackImage(UIImage(named:"pet_func_listen_slide"), for: .normal)
//        //slider.setMinimumTrackImage(UIImage(named:"pet_func_listen_slide"), for: .normal)
//        slider.setThumbImage(UIImage(named: "pet_func_listen_slide"), for: .normal)
//        //使用三宫格缩放
//        let image = UIImage(named: "pet_func_listen_slide")?.stretchableImage(withLeftCapWidth: 14, topCapHeight: 0)//左右像素为14px，中间缩放
//        //slider.setMaximumTrackImage(image, for: .normal)
//        //Slider值改变响应
//        slider.isContinuous = false//设置在停止滑动时才出发响应事件
//        slider.addTarget(self, action: #selector(SliderChanged), for: .valueChanged)
//        return slider
//    }()

import UIKit

@objc protocol CBPetCutmoSlideViewDelegate:NSObjectProtocol {
    @objc func returnSlideValue(slideValue:String)
}

class CBPetCustomSlideView: CBPetBaseView {
    
    private lazy var lineView:UIView = {
        let line = UIView()
        line.backgroundColor = KPetLineColor
        return line
    }()
    private lazy var slideDynamicView:UIView = {
        let vv = UIView()
        vv.backgroundColor = KPetAppColor
        return vv
    }()
    private lazy var panGes:UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(panAction))
        return pan
    }()
    private lazy var slideBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton(imageName: "pet_func_listen_slide")
        btn.alpha = 1
        //let panGes = UIPanGestureRecognizer.init(target: self, action: #selector(panAction))
        btn.addGestureRecognizer(self.panGes)
        return btn
    }()
    public lazy var dataSourceArray:[String] = {
        let arr = [String]()
        return arr
    }()
    private lazy var arrayCornerView:[UIView] = {
        let arr = [UIView]()
        return arr
    }()
    private lazy var arrayBottomLabel:[UILabel] = {
        let arr = [UILabel]()
        return arr
    }()
    /* 滑动间隔*/
    private var slideSpacing:Float = 0.0
    weak var slideDeleate:CBPetCutmoSlideViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        /* 更新frame*/
        self.lineView.snp_updateConstraints { (make) in
            make.top.equalTo(10*KFitHeightRate)
            make.left.right.equalTo(0)
            make.height.equalTo(3*KFitHeightRate)
        }
        if self.dataSourceArray.count == 0 { return CBLog(message: "请添加数据源[String],eg:['5','10','15'...]") }
        let spacingTemp = self.frame.size.width/CGFloat(self.dataSourceArray.count-1)
        for index in 0..<self.arrayCornerView.count {
            let cornerView = self.arrayCornerView[index]
            cornerView.snp_updateConstraints { (make) in
                make.centerY.equalTo(self.lineView)
                make.centerX.equalTo(self.lineView.snp_left).offset(CGFloat(index)*spacingTemp)
                make.size.equalTo(CGSize(width: 8*KFitHeightRate, height: 8*KFitHeightRate))
            }
            let lb = self.arrayBottomLabel[index]
            lb.snp_updateConstraints { (make) in
                make.top.equalTo(self.lineView.snp_bottom).offset(8*KFitHeightRate)
                make.centerX.equalTo(self.lineView.snp_left).offset(CGFloat(index)*spacingTemp)
            }
        }
        self.bringSubviewToFront(self.slideDynamicView)
        self.bringSubviewToFront(self.slideBtn)
        let maxNum = Float(self.dataSourceArray.last! as String)
        let minNum = Float(self.dataSourceArray.first! as String)
        slideSpacing = Float((maxNum! - minNum!)/Float(self.frame.width))
        
    }
    private func setupView() {
        self.backgroundColor = UIColor.white
        self.addSubview(self.lineView)
        self.lineView.snp_makeConstraints { (make) in
            make.top.equalTo(10*KFitHeightRate)
            make.left.right.equalTo(0)
            make.height.equalTo(3*KFitHeightRate)
        }
        setSlideDataSource(dataSourse: [], hideTargetIndex: [])
        self.addSubview(self.slideDynamicView)
        self.slideDynamicView.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.lineView)
            make.left.equalTo(0)
            make.size.equalTo(CGSize(width: 0, height: 3*KFitHeightRate))
        }
        
        self.addSubview(self.slideBtn)
        let slideImage = UIImage(named: "pet_func_listen_slide")!
        self.slideBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.lineView)
            make.centerX.equalTo(self.snp_left).offset(0)
            make.size.equalTo(CGSize(width: slideImage.size.width + 30, height: slideImage.size.height + 30))
        }
    }
    //MARK: - 设置value
    func setSliderValue(value:Float) {
        self.updateProgreess(value: value)
    }
    //MARK: - 添加圆点view
    public func setSlideDataSource(dataSourse:[String],hideTargetIndex:[Int]) {
        self.dataSourceArray = dataSourse
        for vv in self.arrayCornerView {
            vv.removeFromSuperview()
        }
        for vv in self.arrayBottomLabel {
            vv.removeFromSuperview()
        }
        self.arrayCornerView.removeAll()
        self.arrayBottomLabel.removeAll()
        self.lineView.snp_updateConstraints { (make) in
            make.top.equalTo(10*KFitHeightRate)
            make.left.right.equalTo(0)
            make.height.equalTo(3*KFitHeightRate)
        }
        
        if self.dataSourceArray.count == 0 { return CBLog(message: "请添加数据源[String],eg:['5','10','15'...]") }
        let spacingTemp = self.frame.size.width/CGFloat(self.dataSourceArray.count-1)
        for index in 0..<self.dataSourceArray.count {
            let cornerView = createCornerView()
            cornerView.setTitle(self.dataSourceArray[index], for: .normal)
            cornerView.addTarget(self, action: #selector(cornerViewClick), for: .touchUpInside)
            self.addSubview(cornerView)
            self.arrayCornerView.append(cornerView)
            cornerView.snp_makeConstraints { (make) in
                make.centerY.equalTo(self.lineView)
                make.centerX.equalTo(self.lineView.snp_left).offset(CGFloat(index)*spacingTemp)
                make.size.equalTo(CGSize(width: 8*KFitHeightRate, height: 8*KFitHeightRate))
            }
            let lb = UILabel(text: self.dataSourceArray[index], textColor: KPet666666Color, font: UIFont(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!, textAlignment: .center)
            self.addSubview(lb)
            self.arrayBottomLabel.append(lb)
            lb.snp_makeConstraints { (make) in
                make.top.equalTo(self.lineView.snp_bottom).offset(8*KFitHeightRate)
                make.centerX.equalTo(self.lineView.snp_left).offset(CGFloat(index)*spacingTemp)
            }
            for tgetIndex in 0..<hideTargetIndex.count {
                /* 隐藏的目标*/
                if index == hideTargetIndex[tgetIndex] {
                    cornerView.isHidden = true
                    lb.isHidden = true
                }
            }
        }
        self.bringSubviewToFront(self.slideDynamicView)
        self.bringSubviewToFront(self.slideBtn)
        let maxNum = Float(self.dataSourceArray.last! as String)
        let minNum = Float(self.dataSourceArray.first! as String)
        slideSpacing = Float((maxNum! - minNum!)/Float(self.frame.width))
    }
    //MARK: - 滑动手势
    @objc private func panAction(panGes:UIPanGestureRecognizer) {
        if self.dataSourceArray.count == 0 { CBLog(message: "请添加数据源[String],eg:['5','10','15'...]") }
        switch panGes.state {
        case .changed:
            let offset = panGes.translation(in: self)
            let y = panGes.view?.center.y
            var x = (panGes.view?.center.x)! + offset.x
            if x < self.lineView.frame.origin.x {
                x = self.lineView.frame.origin.x
            }
            if x > self.frame.size.width {
                x = self.frame.size.width
            }
            panGes.view?.center = CGPoint(x: x, y: y!)
            panGes.setTranslation(CGPoint(x: 0, y: 0), in: self)
            self.slideDynamicView.snp_updateConstraints { (make) in
                make.centerY.equalTo(self.lineView)
                make.left.equalTo(0)
                make.size.equalTo(CGSize(width: x, height: 3*KFitHeightRate))
            }
            let slideImage = UIImage(named: "pet_func_listen_slide")!
            self.slideBtn.snp_updateConstraints { (make) in
                make.centerY.equalTo(self.lineView)
                make.centerX.equalTo(self.snp_left).offset(x)
                make.size.equalTo(CGSize(width: slideImage.size.width + 30, height: slideImage.size.height + 30))
            }
            let startNum = Float(self.dataSourceArray.first! as String)
            let result = startNum! + slideSpacing*Float(x)
            /* 四舍五入保留1位，即整数*/
            let resultStr = String(format: "%.0f", result)
            if self.slideDeleate != nil {
                if (self.slideDeleate?.responds(to: #selector(self.slideDeleate?.returnSlideValue(slideValue:))))! {
                    self.slideDeleate?.returnSlideValue(slideValue: resultStr)
                }
            }
            CBLog(message: "滑动偏移量:\(x)")
            CBLog(message: "滑动:\(result)")
            /* 更新cornerView背景色*/
            self.updateCornerViewBgm(x)
            break
        case .ended:
            break
        default:
            break
        }
    }
    //MARK: - 更新cornerView背景色
    /* 更新cornerView背景色*/
    @objc private func updateCornerViewBgm(_ space:CGFloat) {
        for (_,cornerView) in self.arrayCornerView.enumerated() {
            //print("下标:\(index)==圆view+\(cornerView.center.x) =偏移:=\(space)=间隔=\(spacingTemp)")
            if cornerView.center.x <= space {
                cornerView.backgroundColor = KPetAppColor
            } else {
                cornerView.backgroundColor = KPetLineColor
            }
        }
    }
    private func createCornerView() -> CBPetBaseButton {
        let corner = CBPetBaseButton.init()
        corner.setTitleColor(UIColor.clear, for: .normal)
        corner.setTitleColor(UIColor.clear, for: .highlighted)
        corner.setTitleColor(UIColor.clear, for: .selected)
        corner.backgroundColor = KPetLineColor
        corner.layer.cornerRadius = 4*KFitHeightRate
        return corner
    }
    @objc private func cornerViewClick(sender:CBPetBaseButton) {
        self.updateProgreess(value: Float(sender.titleLabel?.text ?? "0")!)
        if self.slideDeleate != nil {
            if (self.slideDeleate?.responds(to: #selector(self.slideDeleate?.returnSlideValue(slideValue:))))! {
                self.slideDeleate?.returnSlideValue(slideValue: sender.titleLabel?.text ?? "0")
            }
        }
    }
    private func updateProgreess(value:Float) {
        let startNum = Float(self.dataSourceArray.first! as String)!
        let x:CGFloat = CGFloat(value-startNum)/CGFloat(slideSpacing)
        
        self.lineView.snp_updateConstraints { (make) in
            make.top.equalTo(10*KFitHeightRate)
            make.left.right.equalTo(0)
            make.height.equalTo(3*KFitHeightRate)
        }
        self.slideDynamicView.snp_updateConstraints { (make) in
            make.centerY.equalTo(self.lineView)
            make.left.equalTo(0)
            make.size.equalTo(CGSize(width: x, height: 3*KFitHeightRate))
        }
        let slideImage = UIImage(named: "pet_func_listen_slide")!
        self.slideBtn.snp_updateConstraints { (make) in
            make.centerY.equalTo(self.lineView)
            make.centerX.equalTo(self.snp_left).offset(x)
            make.size.equalTo(CGSize(width: slideImage.size.width + 30, height: slideImage.size.height + 30))
        }
        /* 更新cornerView背景色*/
        self.updateCornerViewBgm(x)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
