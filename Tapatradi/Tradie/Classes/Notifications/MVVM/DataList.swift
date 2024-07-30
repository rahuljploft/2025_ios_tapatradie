//
//  DataList.swift
//  Tradie
//
//  Created by mac on 07/03/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

typealias JsonDictionay = NSDictionary

protocol DataList {
    init?(json: JsonDictionay )
}

extension DataList {

    ///Create array of items from json
    static func getList(_ json: JsonDictionay, _ key:String) -> [Self]? {
        guard let jsonDictionaries = json[key] as? [JsonDictionay] else { return nil }
        
        var array = [Self]()
        
        for jsonDictionary in jsonDictionaries {
            guard let instance = Self.init(json: jsonDictionary) else { return nil }
            array.append(instance)
        }
        
        return array
    }
}
