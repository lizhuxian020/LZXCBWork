//
//  UITextField+Extension.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/5/29.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class UITextField_Extension: NSObject {
}
/// 默认最大输入字数为15
var maxTextNumberDefault = 15
extension UITextField {
    
    convenience init(text:String) {
        self.init()
        self.text = text
    }
    convenience init(text:String,textColor:UIColor) {
        self.init()
        self.text = text
        self.textColor = textColor
    }
    convenience init(font:UIFont) {
        self.init()
        self.font = font
    }
    convenience init(text:String,textColor:UIColor,font:UIFont) {
        self.init()
        self.text = text
        self.textColor = textColor
        self.font = font
    }
    convenience init(placeholder:String) {
        self.init()
        self.placeholder = placeholder
    }
    convenience init(text:String,textColor:UIColor,font:UIFont,placeholder:String) {
        self.init()
        self.text = text
        self.textColor = textColor
        self.font = font
        self.placeholder = placeholder
    }
    convenience init(text:String,textColor:UIColor,
                     font:UIFont,
                     placeholder:String,
                     cornerRadius:CGFloat) {
        self.init()
        self.text = text
        self.textColor = textColor
        self.font = font
        self.placeholder = placeholder
        self.layer.cornerRadius = cornerRadius
    }
    convenience init(text:String,
                     textColor:UIColor,
                     font:UIFont,
                     placeholder:String,
                     placeholderColor:UIColor,
                     placeholderFont:UIFont) {
        self.init()
        self.text = text
        self.textColor = textColor
        self.font = font
        self.placeholder = placeholder
        /* placeholder一定要放在后面，否则会导致设置placeholder字体大小无效 */
        self.attributedPlaceholder = NSAttributedString.init(string:placeholder, attributes: [NSAttributedString.Key.font:placeholderFont])
        self.attributedPlaceholder = NSAttributedString.init(string:placeholder, attributes: [NSAttributedString.Key.foregroundColor:placeholderColor])
    }
    convenience init(textColor:UIColor,
                     font:UIFont,
                     placeholder:String,
                     placeholderColor:UIColor,
                     placeholderFont:UIFont) {
        self.init()
        self.textColor = textColor
        self.font = font
        self.placeholder = placeholder
        /* placeholder一定要放在后面，否则会导致设置placeholder字体大小无效 */
        self.attributedPlaceholder = NSAttributedString.init(string:placeholder, attributes: [NSAttributedString.Key.font:placeholderFont])
        self.attributedPlaceholder = NSAttributedString.init(string:placeholder, attributes: [NSAttributedString.Key.foregroundColor:placeholderColor])
    }
    ///限制TextField的输入字数
    public var maxTextNumber:Int {
        set {
            objc_setAssociatedObject(self, &maxTextNumberDefault, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            if let rs = objc_getAssociatedObject(self, &maxTextNumberDefault) as? Int {
                return rs
            }
            return 15
        }
    }
    
    public func addChangeTextTarget() {
        self.addTarget(self, action: #selector(changeText), for: .editingChanged)
    }
    @objc private func changeText(){
        //判断是不是在拼音状态,拼音状态不截取文本
        if let positionRange = self.markedTextRange {
            guard self.position(from: positionRange.start, offset: 0) != nil else {
                checkTextFieldText()
                return
            }
            
        } else {
            checkTextFieldText()
        }
    }
    /// 检测如果输入数高于设置最大输入数则截取
    private func checkTextFieldText(){
        guard (self.text?.utf16.count)! <= self.maxTextNumber  else {
            guard let text = self.text else {
                return
            }
            /// emoji的utf16.count是2，所以不能以maxTextNumber进行截取，改用text.count-1
            if self.maxTextNumber > text.count {
                /* 限制数 大于 拼音出来的字符数 时，以拼音出来的字符数为准 */
                let sIndex = text.index(text.startIndex, offsetBy: text.count) //-1
                self.text = String(text[..<sIndex])
            } else {
                /* 限制数 小于 拼音出来的字符数 时，以限制数为准 */
                let sIndex = text.index(text.startIndex, offsetBy: self.maxTextNumber)
                self.text = String(text[..<sIndex])
            }
            return
        }
    }
}
