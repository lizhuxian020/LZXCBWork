//
//  UIButton+Extension.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/4/23.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class UIButton_Extension: NSObject {
    
}

let DEFAULT_SPACING = 6.0

extension UIButton {
    
    enum CBBtnLayoutStatus {
        /* 水平字左图右*/
        case CBHorizontalCenterTitleAndImage
        /* 水平字友图左*/
        case CBHorizontalCenterImageAndTitle
        /* 垂直字左图右*/
        case CBVerticalCenterTitleAndImage
        /* 垂直字右图左*/
        case CBVerticalCenterImageAndTitle
    }
    //MARK: - 设置button图片和文字的位置
    /* 设置button图片和文字的位置*/
    func layoutBtn(status:CBBtnLayoutStatus,space:CGFloat) {
        let imgWidth = self.imageView!.bounds.size.width;
        let imgHeight = self.imageView!.bounds.size.height;
        var labWidth = self.titleLabel!.bounds.size.width;
        let labHeight = self.titleLabel!.bounds.size.height;
        let textSize = NSString(string: self.titleLabel!.text!).size(withAttributes: [NSAttributedString.Key.font:self.titleLabel!.font as Any])
        let frameSize = CGSize(width: textSize.width, height: textSize.height);
        if (labWidth < frameSize.width) {
            labWidth = frameSize.width;
        }
        let kMargin = space/2.0;
        switch status {
            case .CBHorizontalCenterTitleAndImage:
                self.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -kMargin, bottom: 0, right: kMargin)
                self.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: kMargin, bottom: 0, right: -kMargin)
                break
            case .CBHorizontalCenterImageAndTitle:
                self.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: labWidth + kMargin, bottom: 0, right: -labWidth - kMargin)
                self.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -imgWidth - kMargin, bottom: 0, right: imgWidth + kMargin)
                break
            case .CBVerticalCenterTitleAndImage:
                self.imageEdgeInsets = UIEdgeInsets.init(top: labHeight + space,left: 0, bottom: 0, right: -labWidth)
                self.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -imgWidth, bottom: imgHeight + space, right: 0)
                break
            case .CBVerticalCenterImageAndTitle:
                self.imageEdgeInsets = UIEdgeInsets.init(top: 0,left: 0, bottom: labHeight + space, right: -labWidth)
                self.titleEdgeInsets = UIEdgeInsets.init(top: imgHeight + space, left: -imgWidth, bottom: 0, right: 0)
                break
        }
    }
    //MARK: - 下划线
    public func underline() {
        guard let text = self.titleLabel?.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
        self.setAttributedTitle(attributedString, for: .normal)
    }
    //MARK: - 便利构造器
    convenience init(backgroundColor:UIColor) {
        self.init()
        self.backgroundColor = backgroundColor
    }
    convenience init(title:String) {
        self.init()
        setTitle(title, for: .normal)
        setTitle(title, for: .highlighted)
    }
    convenience init(title:String,titleColor:UIColor) {
        self.init()
        setTitle(title, for: .normal)
        setTitle(title, for: .highlighted)
        setTitleColor(titleColor, for: .normal)
        setTitleColor(titleColor, for: .highlighted)
    }
    convenience init(title:String,titleColor:UIColor,font:UIFont) {
        self.init()
        setTitle(title, for: .normal)
        setTitle(title, for: .highlighted)
        setTitleColor(titleColor, for: .normal)
        setTitleColor(titleColor, for: .highlighted)
        titleLabel?.font = font
    }
    convenience init(title:String,titleColor:UIColor,font:UIFont,borderWidth:CGFloat,borderColor:UIColor,cornerRadius:CGFloat) {
        self.init()
        setTitle(title, for: .normal)
        setTitle(title, for: .highlighted)
        setTitleColor(titleColor, for: .normal)
        setTitleColor(titleColor, for: .highlighted)
        titleLabel?.font = font
        layer.masksToBounds = true
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        layer.cornerRadius = cornerRadius
    }
    convenience init(title:String,titleColor:UIColor,font:UIFont,backgroundColor:UIColor) {
        self.init()
        setTitle(title, for: .normal)
        setTitle(title, for: .highlighted)
        setTitleColor(titleColor, for: .normal)
        setTitleColor(titleColor, for: .highlighted)
        titleLabel?.font = font
        self.backgroundColor = backgroundColor
    }
    convenience init(title:String,titleColor:UIColor,
                     font:UIFont,
                     backgroundColor:UIColor,
                     cornerRadius:CGFloat) {
        self.init()
        setTitle(title, for: .normal)
        setTitle(title, for: .highlighted)
        setTitleColor(titleColor, for: .normal)
        setTitleColor(titleColor, for: .highlighted)
        titleLabel?.font = font
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
    }
    convenience init(imageName:String) {
        self.init()
        setImage(UIImage(named: imageName), for: .normal)
        setImage(UIImage(named: imageName), for: .highlighted)
    }
    convenience init(title:String,titleColor:UIColor,font:UIFont,imageName:String) {
        self.init()
        setTitle(title, for: .normal)
        setTitle(title, for: .highlighted)
        setTitleColor(titleColor, for: .normal)
        setTitleColor(titleColor, for: .highlighted)
        titleLabel?.font = font
        setImage(UIImage(named: imageName), for: .normal)
        setImage(UIImage(named: imageName), for: .highlighted)
    }
    func setShadow(backgroundColor:UIColor,
                   shadowColor:UIColor,
                   shadowOpacity:Float,
                   shadowOffset:CGSize,
                   shadowRadius:CGFloat) {
        /* 设置背景颜色*/
        self.backgroundColor = backgroundColor
        /* 设置阴影的颜色*/
        self.layer.shadowColor = shadowColor.cgColor
        /* 设置阴影的透明度*/
        self.layer.shadowOpacity = shadowOpacity
        /* 设置阴影的偏移量*/
        self.layer.shadowOffset = shadowOffset
        /* 阴影半径 */
        self.layer.shadowRadius = shadowRadius
    }
    func setShadow(backgroundColor:UIColor,
                   cornerRadius:CGFloat,
                   shadowColor:UIColor,
                   shadowOpacity:Float,
                   shadowOffset:CGSize,
                   shadowRadius:CGFloat) {
        /* 设置背景颜色*/
        self.backgroundColor = backgroundColor
        /* 设置圆角*/
        self.layer.cornerRadius = cornerRadius
        /* 设置阴影的颜色*/
        self.layer.shadowColor = shadowColor.cgColor
        /* 设置阴影的透明度*/
        self.layer.shadowOpacity = shadowOpacity
        /* 设置阴影的偏移量*/
        self.layer.shadowOffset = shadowOffset
        /* 阴影半径 */
        self.layer.shadowRadius = shadowRadius
    }
}
