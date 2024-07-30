//
//  NTFLModel.swift
//  TapATradie
//
//  Created by mac on 07/03/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import Foundation

protocol NTFExtension {
    init?(json: JsonDictionay )
}

extension NTFExtension {

    ///Create array of items from json
    static func createRequiredInstances(from json: JsonDictionay , key:String) -> [Self]? {
        guard let jsonDictionaries = json[key] as? [JsonDictionay] else { return nil }
        var array = [Self]()
        for jsonDictionary in jsonDictionaries {
            guard let instance = Self.init(json: jsonDictionary) else { return nil }
            array.append(instance)
        }
        return array
    }
}
