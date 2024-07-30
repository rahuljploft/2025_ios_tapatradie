//
//  NTFMV.swift
//  TapATradie
//
//  Created by mac on 07/03/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class TapATradie_NTFMV: TapATradie_DataList {
    required convenience init?(json: TapATradie_JsonDictionay) {
        let model = TapATradie_NTFModel.init(json: json)!

        self.init (model)
    }
    
    var titleColor : UIColor {
        if model?.read == "0" {
            return UIColor.black.withAlphaComponent(0.87)
        } else {
            return UIColor.TapATradie_hexColor(0x707070)
        }
    }
    
    var hideReadImage: Bool {
        if model?.read == "0" {
            return false
        } else {
            return true
        }
    }
    
    var title: String? {
        return "Title : " + model!.title!
    }
    
    var desc: String? {
        return "Message : " + model!.message!
    }
    
    var model: TapATradie_NTFModel?
    
    init (_ model: TapATradie_NTFModel) {
        self.model = model
    }
}
