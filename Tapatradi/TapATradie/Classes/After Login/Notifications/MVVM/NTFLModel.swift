//
//  NTFLModel.swift
//  TapATradie
//
//  Created by mac on 07/03/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import Foundation

struct NTFLModel {
    var success: String?
    var data1: [NTFModel]?
    var data: [NTFMV]?
    
    init(_ success: String?, _ data1: [NTFModel]?, _ data: [NTFMV]?){
        self.success = success
        self.data1  = data1
        self.data  = data
    }
    
    init?(_ json: JsonDictionay) {
        let success = json.string("success")
        let data1 = NTFModel.getList(json, "data")
        let data = NTFMV.getList(json, "data")
        
        self.init(success, data1, data)
    }
}
