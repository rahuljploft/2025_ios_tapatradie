//
//  NTFLModel.swift
//  TapATradie
//
//  Created by mac on 07/03/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import Foundation

struct TapATradie_NTFLModel {
    var success: String?
    var data1: [TapATradie_NTFModel]?
    var data: [TapATradie_NTFMV]?
    
    init(_ success: String?, _ data1: [TapATradie_NTFModel]?, _ data: [TapATradie_NTFMV]?){
        self.success = success
        self.data1  = data1
        self.data  = data
    }
    
    init?(_ json: TapATradie_JsonDictionay) {
        let success = json.string("success")
        let data1 = TapATradie_NTFModel.getList(json, "data")
        let data = TapATradie_NTFMV.getList(json, "data")
        
        self.init(success, data1, data)
    }
}
