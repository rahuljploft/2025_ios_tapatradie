//
//  NTFModel.swift
//  TapATradie
//
//  Created by mac on 07/03/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import Foundation

struct TapATradie_NTFModel: TapATradie_DataList {
    var action: String?
    var id: String?
    var message: String?
    var read: String?
    var reciver_id: String?
    var sender_id: String?
    var slug: String?
    var time: String?
    var title: String?
    
    init (_ action: String?, _ id: String?, _ message: String?, _ read: String?, _ reciver_id: String?, _ sender_id: String?, _ slug: String?, _ time: String?, _ title: String?) {
        self.action = action
        self.id = id
        self.message = message
        self.read = read
        self.reciver_id = reciver_id
        self.sender_id = sender_id
        self.slug = slug
        self.time = time
        self.title = title
    }
    
    init?(json: TapATradie_JsonDictionay) {
        let action = json.string("action")
        let id = json.string("id")
        let message = json.string("message")
        let read = json.string("read")
        let reciver_id = json.string("reciver_id")
        let sender_id = json.string("sender_id")
        let slug = json.string("slug")
        let time = json.string("time")
        let title = json.string("title")
        
        self.init(action, id, message, read, reciver_id, sender_id, slug, time, title)
    }
}
