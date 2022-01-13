//
//  UIImage+Extension.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/3/18.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit
import QuartzCore
import Accelerate

//MARK: - 颜色转UIImage
extension UIImage {
    public convenience init?(color:UIColor,size:CGSize = CGSize(width: 1.0, height: 1.0)) {
        UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.main.scale)
        /* defer 所声明的 block 会在当前代码执行退出后被调用。
         正因为它提供了一种延时调用的方式，
         所以一般会被用来做资源释放或者销毁，这在某个函数有多个返回出口的时候特别有用*/
        defer {
            UIGraphicsEndPDFContext()
        }
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect(origin: CGPoint.zero, size: size))
        context?.setShouldAntialias(true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        guard let cgImage = image?.cgImage else {
            self.init()
            return nil
        }
        self.init(cgImage:cgImage)
    }
    /* 修改图片尺寸*/
    class func imageByScalingAndCroppingForSourceImage(sourceImage:UIImage,targetSize:CGSize) -> UIImage {
        var newImage:UIImage? = nil
        let imageSize = sourceImage.size
        let width = imageSize.width
        let height = imageSize.height
        let targetWidth = targetSize.width
        let targetHeight = targetSize.height
        var scaleFactor = 0.0
        var scaleWidth = targetWidth
        var scaleHeight = targetHeight
        var thumbnailPoint = CGPoint(x: 0.0, y: 0.0)
        if __CGSizeEqualToSize(imageSize, targetSize) == false {
            let widthFactor = targetWidth / width
            let heightFactor = targetHeight / height
            if widthFactor > heightFactor {
                scaleFactor = Double(CGFloat(widthFactor))
            } else {
                scaleFactor = Double(CGFloat(heightFactor))
            }
            scaleWidth = width*CGFloat(scaleFactor)
            scaleHeight = height*CGFloat(scaleFactor)
            if widthFactor > heightFactor {
                thumbnailPoint.y = (targetHeight - scaleHeight)*0.5
            } else if widthFactor < heightFactor {
                thumbnailPoint.x = (targetWidth - scaleWidth)*0.5
            }
        }
        UIGraphicsBeginImageContext(targetSize)
        var thumbnailRect = CGRect(x: 0, y: 0, width: 0, height: 0)
        thumbnailRect.origin = thumbnailPoint
        thumbnailRect.size.width = scaleWidth
        thumbnailRect.size.height = scaleHeight
        
        sourceImage.draw(in: thumbnailRect)
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    func imageConvertRoundCorner(radius:CGFloat,borderWidth:CGFloat,borderColor:UIColor) -> UIImage {
        return self.imageByRoundCorner(radius: radius, corners: UIRectCorner.allCorners, borderWidth: borderWidth, borderColor: borderColor, borderLineJoin: CGLineJoin.miter)
    }
    private func imageByRoundCorner(radius:CGFloat,
                                    corners:UIRectCorner,
                                    borderWidth:CGFloat,
                                    borderColor:UIColor,
                                    borderLineJoin:CGLineJoin) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
//        context?.ctm.scaledBy(x: 1, y: -1)
//        context?.ctm.translatedBy(x: 0, y: -rect.size.height)
        context!.scaleBy(x: 1, y: -1)
        context?.translateBy(x: 0, y: -rect.size.height)
        
        let miniSize = min(self.size.width, self.size.height)
        if borderWidth < miniSize/2 {
            let path = UIBezierPath.init(roundedRect: rect.insetBy(dx: borderWidth, dy: borderWidth), byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: borderWidth))
            path.close()
            context?.saveGState()
            path.addClip()
            context?.draw(self.cgImage!, in: rect)
            context?.restoreGState()
        }
        //(borderColor != nil) &&
        if (borderWidth < miniSize/2 && borderWidth > 0) {
            let strokeInset = (floor(borderWidth*self.scale) + 0.5)/self.scale
            let strokeRect = rect.insetBy(dx: strokeInset, dy: strokeInset)
            let strokeRadius:CGFloat?
            if radius > self.scale/2 {
                strokeRadius = radius - self.scale/2
            } else {
                strokeRadius = 0
            }
            let path = UIBezierPath.init(roundedRect: strokeRect, byRoundingCorners: corners, cornerRadii: CGSize(width: strokeRadius!, height: borderWidth))
            path.close()
            
            path.lineWidth = borderWidth
            path.lineJoinStyle = borderLineJoin
            borderColor.setStroke()
            path.stroke()
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    func reSize(newSize:CGSize) -> UIImage {
        let hasAlpha = false  /// false 新图片没有四角 true 新图片有四角
        let scale:CGFloat = 0.0
        //UIGraphicsBeginImageContext(newSize)
        UIGraphicsBeginImageContextWithOptions(newSize, !hasAlpha, scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        let resizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return resizeImage
    }
}
