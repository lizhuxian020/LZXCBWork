//
//  UIView+Extension.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/7.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class UIView_Extension: NSObject {
}

var tapIdentity = 15
var tapGesId = 16
extension UIView {
    
    public var tapBlk: (()->Void)? {
        set {
            if self.tapGes == nil {
                let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
                self.addGestureRecognizer(tap)
                self.tapGes = tap
            }
            objc_setAssociatedObject(self, &tapIdentity, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &tapIdentity) as? ()->Void
        }
    }
    
    public var tapGes : UITapGestureRecognizer? {
        set {
            objc_setAssociatedObject(self, &tapGesId, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &tapGesId) as? UITapGestureRecognizer
        }
    }
    
    @objc private func tapAction() {
        self.tapBlk?()
    }
    
    convenience init(backgroundColor:UIColor,
                     cornerRadius:CGFloat,
                     shadowColor:UIColor,
                     shadowOpacity:Float,
                     shadowOffset:CGSize,
                     shadowRadius:CGFloat) {
        self.init()
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
    convenience init(backgroundColor:UIColor,
                     shadowColor:UIColor,
                     shadowOpacity:Float,
                     shadowOffset:CGSize,
                     shadowRadius:CGFloat) {
        self.init()
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
    func setViewShadow(backgroundColor:UIColor,
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
    func setViewShadow(backgroundColor:UIColor,
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
    
    func snapShotImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return UIImage.init()
        }
        self.layer.render(in: context)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img ?? UIImage.init()
    }
}
