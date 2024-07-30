//
//  File.swift
//  Common
//
//  Created by Admin on 20/02/23.
//

import Foundation



struct ServiceList: Codable {
    let data: [ServiceListData]?
    let message: String?
    let selectedServices, success: Int?

    enum CodingKeys: String, CodingKey {
        case data, message
        case selectedServices = "selected_services"
        case success
    }
}

// MARK: - Datum
struct ServiceListData: Codable {
    let assign: String?
    let id: Int?
    //let createdBy, id: Int?
    //let createdOn: Int?
    let image, imageLink, name, salesforceID: String?
    let status, type: String?
    //let updatedBy, updatedOn: Int?

    enum CodingKeys: String, CodingKey {
        case assign
        //case createdBy = "created_by"
        //case createdOn = "created_on"
        case id, image
        case imageLink = "image_link"
        case name
        case salesforceID = "salesforce_id"
        case status, type
        //case updatedBy = "updated_by"
        //case updatedOn = "updated_on"
    }
}



// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct GetAddressModel: Codable {
    let results: [ResultGetAddress]?

    enum CodingKeys: String, CodingKey {
        case results
    }
}


// MARK: - Result
struct ResultGetAddress: Codable {
    let formattedAddress: String?

    enum CodingKeys: String, CodingKey {
        case formattedAddress = "formatted_address"
    }
}

