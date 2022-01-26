//
//  CBPetGMSMarker.swift
//  cobanBnPetSwift
//
//  Created by lee on 2022/1/26.
//  Copyright © 2022 coban. All rights reserved.
//

import Foundation

class CBPetGMSMarker : GMSMarker {
    var petModel : CBPetPsnalCterPetModel? {
        didSet {
        }
    }
    
    var addressStr : String? {
        didSet {
            petModel?.app_addressStr = addressStr
        }
    }
    
    var fenceSwitch : String?
    
    func generateFenceSwitch(_ finishBLK :@escaping ()->Void) {
        
    }
    
    func generateAddressStr(_ finishBLK :@escaping ()->Void) {
        let geocoder = GMSGeocoder.init()
        geocoder.reverseGeocodeCoordinate(petModel!.getCoordinate2D()) {[weak self] response, error in
            if let res = response?.results(),
               res.count > 0 {
                let address = res[0]
                let addressStr = "\(address.country ?? "")" + "\(address.administrativeArea ?? "")" + "\(address.locality ?? "")" + "\(address.subLocality ?? "")" + "\(address.thoroughfare ?? "")"
                self?.addressStr = addressStr
            } else {
                self?.addressStr = "未知".localizedStr
            }
            finishBLK()
        }
    }
}
