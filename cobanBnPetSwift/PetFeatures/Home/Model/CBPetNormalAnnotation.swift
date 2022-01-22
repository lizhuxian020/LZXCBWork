//
//  CBPetNormalAnnotation.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/4/23.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetNormalAnnotation: BMKPointAnnotation {
    var nearPetsModel:CBPetFuncNearPetModel?

    var homeInfoModel : CBPetHomeInfoModel?
    var petModel : CBPetPsnalCterPetModel?
    
    func avatarImgUrl() -> String? {
        if let homeInfo = homeInfoModel {
            return homeInfo.pet.photo
        }
        if let pet = petModel {
            return pet.pet.photo
        }
        return ""
    }
    
    func getCoordinate2D() -> CLLocationCoordinate2D {
        if let homeInfo = homeInfoModel {
            return CLLocationCoordinate2DMake(Double(homeInfo.pet.device.location.lat ?? "0")!, Double(homeInfo.pet.device.location.lng ?? "0")!)
        }
        if let pet = petModel {
            return CLLocationCoordinate2DMake(Double(pet.pet.device.location.lat ?? "0")!, Double(pet.pet.device.location.lng ?? "0")!)
        }
        return CLLocationCoordinate2DMake(0, 0)
    }
    
    func getTimeStr(formatStr: String) -> String {
        var value : String?
        if let homeInfo = homeInfoModel {
            value = homeInfo.pet.device.location.postTime
        }
        if let pet = petModel {
            value = pet.pet.device.location.postTime
        }
        if value != nil {
            if let valueTimeZone = CBPetHomeParamtersModel.getHomeParamters().timeZone {
                return CBPetUtils.convertTimestampToDateStr(timestamp: value!.valueStr, formateStr: "yyyy-MM-dd HH:mm:ss",timeZone: Int(valueTimeZone) ?? 0)
            } else {
                return CBPetUtils.convertTimestampToDateStr(timestamp: value!.valueStr, formateStr: "yyyy-MM-dd HH:mm:ss")
            }
        }
        return ""
    }
    
    func getBattery() -> String {
        if let homeInfo = homeInfoModel {
            return homeInfo.pet.device.location.baterry ?? ""
        }
        if let pet = petModel {
            return pet.pet.device.location.baterry ?? ""
        }
        return ""
    }
    
    func getOnline() -> String {
        if let homeInfo = homeInfoModel {
            return homeInfo.pet.device.online ?? ""
        }
        if let pet = petModel {
            return pet.pet.device.online ?? ""
        }
        return ""
    }
    
    func getSimCardType() -> String {
        if let homeInfo = homeInfoModel {
            return homeInfo.pet.device.simCardType ?? ""
        }
        if let pet = petModel {
            return pet.pet.device.simCardType ?? ""
        }
        return ""
    }
    
    
}
