//
//  UIViewController+Extension.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/4/16.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class UIViewController_Extension: NSObject {

}
extension UIViewController {
    /* 获取当前显示的vc*/
    class func getCurrentVC() -> UIViewController? {
        var currentWindow = UIApplication.shared.keyWindow
        if currentWindow?.windowLevel != UIWindow.Level.normal {
            let windowArr = UIApplication.shared.windows
            for window in windowArr {
                if window.windowLevel == UIWindow.Level.normal {
                    currentWindow = window
                    break
                }
            }
        }
        return UIViewController.getNextController(nextVC: currentWindow?.rootViewController)
    }
    private class func getNextController(nextVC:UIViewController?) -> UIViewController? {
        if nextVC == nil {
            return nil
        } else if nextVC?.presentedViewController != nil {
            return UIViewController.getNextController(nextVC: nextVC?.presentedViewController)
        } else if let tabbar = nextVC as? UITabBarController {
            return UIViewController.getNextController(nextVC: tabbar.selectedViewController)
        } else if let nav = nextVC as? UINavigationController {
            return UIViewController.getNextController(nextVC: nav.visibleViewController)
        }
        return nextVC
    }
}
