//
//  DataList.swift
//  TapATradie
//
//  Created by mac on 07/03/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

typealias TapATradie_JsonDictionay = NSDictionary

protocol TapATradie_DataList {
    init?(json: TapATradie_JsonDictionay )
}

extension TapATradie_DataList {

    //Create array of items from json
    static func getList(_ json: TapATradie_JsonDictionay, _ key:String) -> [Self]? {
        guard let jsonDictionaries = json[key] as? [TapATradie_JsonDictionay] else { return nil }
        
        var array = [Self]()
        
        for jsonDictionary in jsonDictionaries {
            guard let instance = Self.init(json: jsonDictionary) else { return nil }
            array.append(instance)
        }
        
        return array
    }
}
