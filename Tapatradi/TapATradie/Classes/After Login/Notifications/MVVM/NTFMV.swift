//
//  NTFMV.swift
//  TapATradie
//
//  Created by mac on 07/03/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class NTFMV: DataList {
    required convenience init?(json: JsonDictionay) {
        let model = NTFModel.init(json: json)!

        self.init (model)
    }
    
    var titleColor : UIColor {
        if model?.read == "0" {
            return UIColor.black.withAlphaComponent(0.87)
        } else {
            return UIColor.hexColor(0x707070)
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
    
    var model: NTFModel?
    
    init (_ model: NTFModel) {
        self.model = model
    }
}
