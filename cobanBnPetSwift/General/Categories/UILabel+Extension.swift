//
//  UILabel+Extension.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/5/28.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class UILabel_Extension: NSObject {

}
extension UILabel {
    //MARK: - 设置间距
    /* 设置间距*/
    func setColumnSpace(columnSpace:CGFloat) {
        let attributedString = NSMutableAttributedString.init(attributedString: self.attributedText ?? NSAttributedString.init(string: ""))
        /* 调节间距*/
        attributedString.addAttribute(kCTKernAttributeName as NSAttributedString.Key, value: columnSpace, range: NSRange(location: 0, length: attributedString.length))
        self.attributedText = attributedString
    }
    //MARK: - 调整行距
    /* 调整行距*/
    func setRowSpace(rowSpace:CGFloat) {
        self.numberOfLines = 0
        let attributedString = NSMutableAttributedString.init(attributedString: self.attributedText ?? NSAttributedString.init(string: ""))
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = rowSpace
        paragraphStyle.baseWritingDirection = .leftToRight//.natural//.leftToRight
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: self.text!.count))
        self.attributedText = attributedString
    }
    
    convenience init(text:String) {
        self.init()
        self.text = text
        self.numberOfLines = 0
    }
    convenience init(textColor:UIColor) {
        self.init()
        self.textColor = textColor
    }
    convenience init(font:UIFont) {
        self.init()
        self.font = font
    }
    convenience init(textAlignment:NSTextAlignment) {
        self.init()
        self.textAlignment = textAlignment
    }
    convenience init(text:String,textColor:UIColor,font:UIFont) {
        self.init()
        self.text = text
        self.textColor = textColor
        self.font = font
        self.numberOfLines = 0
    }
    convenience init(text:String,textColor:UIColor,font:UIFont,
                     textAlignment:NSTextAlignment) {
        self.init()
        self.text = text
        self.textColor = textColor
        self.font = font
        self.textAlignment = textAlignment
        self.numberOfLines = 0
    }
}
