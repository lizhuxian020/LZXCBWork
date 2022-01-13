//
//  CBPetUtilsCreate.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/5/25.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetUtilsCreate: NSObject {
//    //  新建lab
//    class func createLb(text:String) -> UILabel {
//        let label = UILabel()
//        label.text = text
//        //label.textColor = kCellTextColor
//        //label.font = UIFont.systemFont(ofSize: 15*KFitWidthRate)
//        return label
//    }
//    class func createLb(text:String,size:CGFloat) -> UILabel {
//        let label = createLb(text: text)
//        label.font = UIFont.systemFont(ofSize: size)
//        return label
//    }
//
//    class func createLb(text:String,size:CGFloat,alignment:NSTextAlignment) -> UILabel {
//        let label = createLb(text: text, size: size)
//        label.textAlignment = alignment
//        return label
//    }
//
//    class func createLb(text:String,size:CGFloat,alignment:NSTextAlignment,textColor:UIColor) -> UILabel {
//        let label = createLb(text: text, size: size, alignment: alignment)
//        label.textColor = textColor
//        return label
//    }
////  新建tf
//    class func createTF(holdText:String) -> UITextField {
//        let tf:UITextField = UITextField()
//        let placeholder = NSMutableAttributedString.init(string: holdText)
//        placeholder.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 12*KFitWidthRate)], range: NSRange.init(location: 0, length: holdText.count))
//        placeholder.addAttributes([.foregroundColor:kTextFieldColor], range: NSRange.init(location: 0, length: holdText.count))
//        tf.attributedPlaceholder = placeholder
//        tf.textColor = kTextFieldColor
//        tf.font = UIFont.systemFont(ofSize: 12*KFitWidthRate)
//        tf.textAlignment = .left
//        return tf
//    }
//    class func createTF(holdText:String,fontSize:CGFloat) -> UITextField {
//        let tf = createTF(holdText: holdText)
//        tf.textColor = RGB(r: 96, g: 96, b: 96)
//        tf.font = UIFont.systemFont(ofSize: fontSize)
//        return tf
//    }
//    class func createTF(holdText:String,fontSize:CGFloat,leftView:UIView) -> UITextField {
//        let tf = createTF(holdText: holdText, fontSize: fontSize)
//        tf.textColor = RGB(r: 196, g: 196, b: 196)
//        tf.leftView = leftView
//        tf.leftViewMode = .always
//        return tf
//    }
//    class func createTF(holdText:String,fontSize:CGFloat,leftImage:UIImage,leftImageSize:CGSize) -> UITextField {
//        let imageView = UIImageView.init(image: leftImage)
//        imageView.frame = CGRect.init(x: 0, y: 0, width: leftImageSize.width, height: leftImageSize.height)
//        imageView.contentMode = .center
//        let leftView = UIView.init(frame: imageView.frame)
//        leftView.addSubview(imageView)
//        let tf = createTF(holdText: holdText, fontSize: fontSize, leftView: leftView)
//        return tf
//    }
    
    /// 新建线条view
    class func createLineView() -> UIView {
        let lineView = UIView()
        lineView.backgroundColor = RGB(r: 210, g: 210, b: 210)
        return lineView
    }
    
//    /// 新建btn
//    /// - Parameter title: xx
//    class func createBtn(title:String) -> UIButton {
//        let btn = UIButton.init()
//        btn.setTitle(title, for: .normal)
//        btn.setTitle(title, for: .highlighted)
//        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
//        btn.setTitleColor(kLoginPartColor, for: .normal)
//        btn.setTitleColor(kLoginPartColor, for: .highlighted)
//        return btn
//    }
//    class func createBtn(title:String,titleColor:UIColor) -> UIButton {
//        let btn = createBtn(title: title)
//        btn.setTitleColor(titleColor, for: .normal)
//        btn.setTitleColor(titleColor, for: .highlighted)
//        return btn
//    }
//    class func createBtn(title:String,titleColor:UIColor,fontSize:CGFloat) -> UIButton {
//        let btn = createBtn(title: title, titleColor: titleColor)
//        btn.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
//        return btn
//    }
//    class func createBtn(title:String,titleColor:UIColor,fontSize:CGFloat,backgroundColor:UIColor) -> UIButton {
//        let btn = createBtn(title: title, titleColor: titleColor, fontSize: fontSize)
//        btn.backgroundColor = backgroundColor
//        return btn
//    }
//    class func createBtn(title:String,titleColor:UIColor,fontSize:CGFloat,backgroundColor:UIColor,radius:CGFloat) -> UIButton {
//        let btn = createBtn(title: title, titleColor: titleColor, fontSize: fontSize, backgroundColor: backgroundColor)
//        btn.layer.cornerRadius = radius
//        return btn
//    }
//    class func createBtn(image:UIImage) -> UIButton {
//        let btn = createBtn(normalImage: image, selectImage: image)
//        return btn
//    }
//    class func createBtn(normalImage:UIImage,selectImage:UIImage) -> UIButton {
//        let btn = UIButton.init()
//        btn.setImage(normalImage, for: .normal)
//        btn.setImage(selectImage, for: .selected)
//        return btn
//    }
    
    
}
