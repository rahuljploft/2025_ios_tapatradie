//
//  CheckCode.swift
//  Tradie
//
//  Created by Admin on 11/03/24.
//

import Foundation

// MARK: - Welcome
struct NewUserDeatil_Model: Codable {
    let address: AddressNewUserDeatil?
    let currentMembership: CurrentMembershipNewUserDeatil?
    let data: DataClassNewUserDeatil?
    let message: String?
    let success: Int?

    enum CodingKeys: String, CodingKey {
        case address
        case currentMembership = "current_membership"
        case data, message, success
    }
}

// MARK: - Address
struct AddressNewUserDeatil: Codable {
    let address, city, country, latitude: DynamicObject?
    let longitude, state: DynamicObject?
}

// MARK: - CurrentMembership
struct CurrentMembershipNewUserDeatil: Codable {
    let amount: DynamicObject_Int?
    let androidCustomerID: DynamicObject?
    let createdBy, createdOn, deviceType, endDate: DynamicObject?
    let environment, event: DynamicObject?
    let freeday, id: DynamicObject?
    let iosCustomerID: DynamicObject?
    let isTrail: DynamicObject?
    let orderID, paymentFrom, paymentStatus, planID: DynamicObject?
    let planName, playmentCreateDate: DynamicObject?
    let salesforceID: DynamicObject?
    let startDate: DynamicObject?
    let status, stripeID, subscriptionID: DynamicObject?
    let updatedBy, updatedOn, userID: DynamicObject?

    enum CodingKeys: String, CodingKey {
        case amount
        case androidCustomerID = "android_customer_id"
        case createdBy = "created_by"
        case createdOn = "created_on"
        case deviceType = "device_type"
        case endDate = "end_date"
        case environment, event, freeday, id
        case iosCustomerID = "ios_customer_id"
        case isTrail = "is_trail"
        case orderID = "order_id"
        case paymentFrom = "payment_from"
        case paymentStatus = "payment_status"
        case planID = "plan_id"
        case planName = "plan_name"
        case playmentCreateDate
        case salesforceID = "salesforce_id"
        case startDate = "start_date"
        case status
        case stripeID = "stripe_id"
        case subscriptionID = "subscription_id"
        case updatedBy = "updated_by"
        case updatedOn = "updated_on"
        case userID = "user_id"
    }
}

// MARK: - DataClass
struct DataClassNewUserDeatil: Codable {
    let aboutMe, access, businessName, city: DynamicObject?
    let country, countryCode, dob, email: DynamicObject?
    let fullName, gender: DynamicObject?
    let google, googleRating: DynamicObject?
    let googleBusinessName: DynamicObject?
    let id, lastLogin: DynamicObject?
    let latitude, licenseNumber, longitude: DynamicObject?
    let mobile, online: DynamicObject?
    let onlineAddress, phoneNumber, professionalExperience, profilePic: DynamicObject?
    let registerComplete: DynamicObject?
    let status: DynamicObject?
    let submitForApproval, verified: DynamicObject?
    let websiteLink: DynamicObject?
    let workingRadius: DynamicObject?

    enum CodingKeys: String, CodingKey {
        case aboutMe = "about_me"
        case access
        case businessName = "business_name"
        case city, country
        case countryCode = "country_code"
        case dob, email
        case fullName = "full_name"
        case gender, google, googleRating
        case googleBusinessName = "google_business_name"
        case id
        case lastLogin = "last_login"
        case latitude
        case licenseNumber = "license_number"
        case longitude, mobile, online
        case onlineAddress = "online_address"
        case phoneNumber = "phone_number"
        case professionalExperience = "professional_experience"
        case profilePic = "profile_pic"
        case registerComplete = "register_complete"
        case status
        case submitForApproval = "submit_for_approval"
        case verified
        case websiteLink = "website_link"
        case workingRadius = "working_radius"
    }
}


enum DynamicObject_Int: Codable {
    
    case double(Double)
    case string(String)
    case int(Int)
    case bool(Bool)
    case jsonNul(JSONNull)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Double.self) {
            self = .double(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if let x = try? container.decode(Int.self) {
            self = .int(x)
            return
        }
        if let x = try? container.decode(Bool.self) {
            self = .bool(x)
            return
        }
        if let x = try? container.decode(JSONNull.self) {
            self = .jsonNul(x)
            return
        }
        throw DecodingError.typeMismatch(DynamicObject_Int.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Amount"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .double(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        case .int(let x):
            try container.encode(x)
        case .bool(let x):
            try container.encode(x)
        case .jsonNul(_):
            try container.encodeNil()
        }
    }
    
    var value: Int {
        switch self {
        case .double(let value):
            return Int("\(value)") ?? 0
        case .string(let value):
            return Int("\(value)") ?? 0
        case .int(let value):
            return Int("\(value)") ?? 0
        case .bool(let value):
            return Int("\(value)") ?? 0
        case .jsonNul(_):
            return 0
        }
    }
}

