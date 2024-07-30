//
//  FileNew.swift
//  Common
//
//  Created by Admin on 20/02/23.
//

import Foundation



struct NewLeadsList: Codable {
    let data: [NewLeadsListData]?
    let message: String?
    let success: Int
}

// MARK: - Datum
struct NewLeadsListData: Codable {
    let address, city, country, countryCode: String?
    //let createdBy: Int
    //let createdOn
    let date, detail: String?
    //let dispute: Int?
    let disputeResion: String?
    //let distance: String?
    let email, fullName: String?
    let id: Int?
    let latitude, longitude, mobile, postcode: String?
    let profilePic: String?
    let providerID: Int?
    let providerStatus, salesforceID: String?
    let serviceID: Int?
    let serviceName, serviceType, state, status: String?
    let time, title, tradieType, type: String?
    let uid: Int?
    //let updatedBy: String?
    //let updatedOn
    let userStatus: String?

    enum CodingKeys: String, CodingKey {
        case address, city, country
        case countryCode = "country_code"
        //case createdBy = "created_by"
        //case createdOn = "created_on"
        case date, detail
        //case dispute
        case disputeResion = "dispute_resion"
        //case distance,
        case email
        case fullName = "full_name"
        case id, latitude, longitude, mobile, postcode
        case profilePic = "profile_pic"
        case providerID = "provider_id"
        case providerStatus = "provider_status"
        case salesforceID = "salesforce_id"
        case serviceID = "service_id"
        case serviceName = "service_name"
        case serviceType = "service_type"
        case state, status, time, title
        case tradieType = "tradie_type"
        case type, uid
        //case updatedBy = "updated_by"
        //case updatedOn = "updated_on"
        case userStatus = "user_status"
    }
}
