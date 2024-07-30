//
//  Country.swift
//  Common
//
//  Created by Aman Maharjan on 15/09/2021.
//

import Foundation

public struct Country1: Decodable, Equatable {
    var id: Int
    var iso: String
    var iso3: String?
    var name: String
    var niceName: String
    var numericCode: Int?
    var phoneCode: Int
    
    public init(id: Int, iso: String, iso3: String?, name: String, niceName: String, numericCode: Int?, phoneCode: Int) {
        self.id = id
        self.iso = iso
        self.iso3 = iso3
        self.name = name
        self.niceName = niceName
        self.numericCode = numericCode
        self.phoneCode = phoneCode
    }
}
