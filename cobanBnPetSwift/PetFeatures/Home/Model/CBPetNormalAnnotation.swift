//
//  CBPetNormalAnnotation.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/4/23.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetNormalAnnotation: BMKPointAnnotation {
    var isFenceCircleMark : Bool = false
    var nearPetsModel:CBPetFuncNearPetModel?

    var petModel : CBPetPsnalCterPetModel?
    
    func avatarImgUrl() -> String? {
        if let pet = petModel {
            return pet.pet.photo
        }
        return ""
    }

    func getCoordinate2D() -> CLLocationCoordinate2D {
        if let pet = petModel {
            return pet.getCoordinate2D()
        }
        return CLLocationCoordinate2DMake(0, 0)
    }
    
}
