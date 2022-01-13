//
//  CBPetCtrlPanelView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/5.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

let ctrlPanelWidth = 46*KFitWidthRate

class CBPetCtrlPanelView: CBPetBaseView {
    
    ///单例
    static let share:CBPetCtrlPanelView = {
        let view = CBPetCtrlPanelView.init()
        return view
    }()
    private lazy var shadowBgmView:UIView = {
        let shadowV = UIView(backgroundColor: UIColor.white, cornerRadius: ctrlPanelWidth/2, shadowColor: UIColor.init().colorWithHexString(hexString: "#2E2F41"), shadowOpacity: 0.35, shadowOffset: CGSize(width: 0, height: 0), shadowRadius: 8)
        return shadowV
    }()
    private lazy var ctrPanelBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton(imageName: "pet_home_controlPanelIcon")
        btn.backgroundColor = UIColor.init().colorWithHexString(hexString: "#2E2F41")
        btn.layer.cornerRadius = ctrlPanelWidth/2
        return btn
    }()
    ///线宽
    var progresslineWidth:CGFloat = 3//10
    ///底线
    var bottomColor:UIColor?
    ///progress线条
    var topColor:UIColor?
    var origin:CGPoint = CGPoint(x: 0, y: 0)//圆点
    var radius:CGFloat = 0                  //半径
    var startAngle:CGFloat = 0              //起始
    var endAngle:CGFloat = 0                //结束
    var drawProgressBlocks:((_ progressfloat: CGFloat)->())?  // 绘制圆环block
    /// 点击按钮的回调
    public var popBlock:((_ isShow:Bool) -> Void)?
    
    private lazy var bottomLayer : CAShapeLayer = {
        let layers = CAShapeLayer()
        layers.fillColor = UIColor.clear.cgColor
        return layers
    }()
    private lazy var topLayer : CAShapeLayer = {
        let layers = CAShapeLayer()
        layers.lineCap = CAShapeLayerLineCap.round
        layers.fillColor = UIColor.clear.cgColor
        return layers
    }()
    //进度label
    private lazy var progressLabel:UILabel = {
        let lab = UILabel()
        lab.frame = CGRect(x: 0, y: 0, width: 50, height: 15)
        lab.center = CGPoint(x: self.bounds.size.width/2, y: -20)
        lab.textColor = UIColor.red
        lab.font = UIFont.systemFont(ofSize: 13)
        lab.textAlignment = .center
        return lab
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    private func setupView() {
        //self.frame = CGRect(x: SCREEN_WIDTH-20*KFitWidthRate-46*KFitWidthRate, y: SCREEN_HEIGHT-240*KFitHeightRate, width: 46*KFitHeightRate, height: 46*KFitHeightRate)
        //拖拽手势
        let panRcognize = UIPanGestureRecognizer.init(target: self, action: #selector(handlePan))
        panRcognize.minimumNumberOfTouches = 1
        panRcognize.isEnabled = true
        panRcognize.delaysTouchesEnded = true
        panRcognize.cancelsTouchesInView = true
        self.addGestureRecognizer(panRcognize)
        
        self.addSubview(self.shadowBgmView)
        self.shadowBgmView.snp_makeConstraints { (make) in
            make.center.equalTo(self)
            make.size.equalTo(CGSize(width: ctrlPanelWidth, height: ctrlPanelWidth))
        }
        self.addSubview(self.ctrPanelBtn)
        self.ctrPanelBtn.snp_makeConstraints { (make) in
            make.center.equalTo(self)
            make.size.equalTo(CGSize(width: ctrlPanelWidth, height: ctrlPanelWidth))
        }
        self.ctrPanelBtn.addTarget(self, action: #selector(popClick), for: .touchUpInside)
        
        /// 外部调用block 回调画圆环
        drawProgressBlocks = { [weak self] (progressfloat:CGFloat) -> Void in
            ///默认外环内环颜色
            self?.topColor = UIColor.init().colorWithHexString(hexString: "#F8563B")
            self?.bottomColor = UIColor.init().colorWithHexString(hexString: "#F8563B", alpha: 0.1)
            self!.drawAction(progressfloat: progressfloat)
        }
    }
    //MARK: - 圆环设置
    private func setupLayer() {
        layer.addSublayer(self.bottomLayer)
        layer.addSublayer(self.topLayer)
        //addSubview(self.progressLabel)
    }
    private func setupRound() {
        origin = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
        radius = self.bounds.size.width/2 - 4
        let bottomPath  = UIBezierPath.init(arcCenter: origin, radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi*2), clockwise: true)
        bottomLayer.path = bottomPath.cgPath
    }
    private func setupLayerColor() {
        bottomLayer.strokeColor = bottomColor?.cgColor
        topLayer.strokeColor = topColor?.cgColor
        topLayer.lineWidth = progresslineWidth
        bottomLayer.lineWidth = progresslineWidth
    }
    //MARK: - 展示
    public func showCtrlPanel(topColor:UIColor,
                              bottomColor:UIColor,
                              progressfloat:CGFloat,
                              popBtnBlock:@escaping (_ isShow:Bool) -> Void) {
        UIApplication.shared.keyWindow?.subviews.forEach({ (vv) in
            if vv is CBPetCtrlPanelView {
                return
            }
        })
        self.frame = CGRect(x: SCREEN_WIDTH-20*KFitWidthRate-ctrlPanelWidth, y: SCREEN_HEIGHT-240*KFitHeightRate, width: ctrlPanelWidth, height: ctrlPanelWidth)
        UIApplication.shared.keyWindow?.addSubview(self)
        self.popBlock = popBtnBlock
        
        self.alpha = 1//0
        self.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3) {
           self.alpha = 1
           self.isUserInteractionEnabled = true
        }
        
        self.topColor = topColor
        self.bottomColor = bottomColor
        ///show 画圆环
        self.drawAction(progressfloat:progressfloat)
    }
    //MARK: - 画圆环
    private func drawAction(progressfloat:CGFloat) {
        CBLog(message: "进度:\(progressfloat)")
        self.setupLayer()
        self.setupRound()
        //self.progressLabel.text = "\(Int(progressfloat*100))" + "%"
        if progressfloat > 0.2 {
            //self.progressLabel.textColor = KPetAppColor
            self.topColor = KPetAppColor
        } else {
            //self.progressLabel.textColor = UIColor.init().colorWithHexString(hexString: "#F8563B")
            self.topColor = UIColor.init().colorWithHexString(hexString: "#F8563B")
        }
        setupLayerColor()
        
        self.startAngle = -CGFloat(CGFloat.pi/2)
        if progressfloat >= 1 {
            /* 100% 显示满格,不考虑圆角误差*/
            self.endAngle = self.startAngle + progressfloat * CGFloat(CGFloat.pi*2)
        } else {
            /* 这里要减去线条圆角导致的误差, 弧长除以半径等于角度 progresslineWidth/self.radius  */
            self.endAngle = self.startAngle + progressfloat * CGFloat(CGFloat.pi*2) - progresslineWidth/self.radius
        }
        
        let topPath  = UIBezierPath.init(arcCenter: self.origin, radius: self.radius, startAngle: self.startAngle, endAngle: self.endAngle, clockwise: true)
        self.topLayer.path = topPath.cgPath
        ///添加动画
        let pathAnimation = CABasicAnimation.init(keyPath: "strokeEnd")
        pathAnimation.duration = 0.5
        pathAnimation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeOut)
        pathAnimation.fromValue = 0
        pathAnimation.toValue = 1
        self.topLayer.add(pathAnimation, forKey: "strokeEndAnimation")
    }
    //MARK: - 按钮点击事件
    @objc private func popClick(sender:CBPetBaseButton) {
        CBLog(message: "控制面板点击事件:\(sender.isSelected)")
        sender.isSelected = !sender.isSelected
        self.ctrPanelBtn.isSelected = sender.isSelected
        guard self.popBlock == nil else {
            self.popBlock!(self.ctrPanelBtn.isSelected)
            return
        }
    }
    //MARK: - 关闭外部弹出的其他视图
    public func dismissCtrlViewClick() {
        self.popClick(sender: self.ctrPanelBtn)
    }
    //MARK: - 关闭本视图
    public func removeView() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.alpha = 0
        }) { [weak self] (res) in
            self?.removeFromSuperview()
        }
    }
    //MARK: - 摇拽手势
    @objc private func handlePan(ges:UIPanGestureRecognizer) {
        /* translationInView：获取到的是手指移动后，在相对坐标中的偏移量 */
        let offset = ges.translation(in: self)
        var center = CGPoint(x: self.center.x+offset.x, y: self.center.y+offset.y)
        if ges.state == .began || ges.state == .changed {
            /* 判断横坐标是否超出屏幕*/ //92+15
            if center.x < ctrlPanelSpace {
                center.x = ctrlPanelSpace

            } else if center.x >= (SCREEN_WIDTH - ctrlPanelSpace) {
                center.x = SCREEN_WIDTH-ctrlPanelSpace
            }
            /* 判断纵坐标是否超出屏幕*/
            if center.y <= (NavigationBarHeigt + 23*KFitHeightRate) {
                center.y = NavigationBarHeigt + 23*KFitHeightRate
            } else if center.y >= SCREEN_HEIGHT-0-0-TabPaddingBARHEIGHT {
                center.y = SCREEN_HEIGHT-0-0-TabPaddingBARHEIGHT
            }
            self.center = center
            /* 设置位置*/
            ges.setTranslation(CGPoint(x: 0, y: 0), in: self)
        } else if ges.state == .ended {
            if center.x > ctrlPanelSpace && center.x <= SCREEN_WIDTH/2 {
                center.x = ctrlPanelSpace
            }  else if center.x > SCREEN_WIDTH/2 && center.x <= SCREEN_WIDTH-ctrlPanelSpace {
                center.x = SCREEN_WIDTH-ctrlPanelSpace
            }
            UIView.animate(withDuration: 0.2, animations: {
                self.center = center
                /* 设置位置*/
                ges.setTranslation(CGPoint(x: 0, y: 0), in: self)
            })
        }
    }
    //MARK: - 视图置顶
    public func bringToFront() {
        UIApplication.shared.keyWindow?.bringSubviewToFront(self)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
