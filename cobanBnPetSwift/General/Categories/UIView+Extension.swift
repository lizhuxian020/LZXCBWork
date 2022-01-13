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
extension UIView {
    
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
}
