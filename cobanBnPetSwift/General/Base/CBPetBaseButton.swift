//
//  CBPetBaseButton.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/5/26.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetBaseButton: UIButton {

    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let zqmargin:CGFloat = -20 //负值是方法响应范围
        let clickArea = bounds.insetBy(dx: zqmargin, dy: zqmargin)
        return clickArea.contains(point)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
