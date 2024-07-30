//
//  UserInfo.swift
//  Zooma
//
//  Created by Avinash somani on 26/12/16.
//  Copyright © 2016 Harish. All rights reserved.
//

import UIKit

class UserInfo: NSObject, Codable, NSCoding {
    let id, state, country_code,country: String?
    let fullName, email, mobile, gender: String?
    let dob, city, professionalExperience: String?
    let phoneNumber, websiteLink, aboutMe, businessName: String?
    let licenseNumber, profilePic, latitude, longitude: String?
    let status, access, lastLogin: String?
    let registerComplete, online, onlineAddress, verified: String?

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case email, mobile, gender, dob, country, country_code, city
        case professionalExperience = "professional_experience"
        case phoneNumber = "phone_number"
        case websiteLink = "website_link"
        case aboutMe = "about_me"
        case businessName = "business_name"
        case licenseNumber = "license_number"
        case profilePic = "profile_pic"
        case latitude, longitude, status, access
        case lastLogin = "last_login"
        case registerComplete = "register_complete"
        case online, verified, state
        case onlineAddress = "online_address"
    }

    public init(_ user: UserInfo) {
        self.country_code = user.country_code
        self.onlineAddress = user.onlineAddress
        self.id = user.id
        self.state = user.state
        self.fullName = user.fullName
        self.email = user.email
        self.mobile = user.mobile
        self.gender = user.gender
        self.dob = user.dob
        self.country = user.country
        self.city = user.city
        self.professionalExperience = user.professionalExperience
        self.phoneNumber = user.phoneNumber
        self.websiteLink = user.websiteLink
        self.aboutMe = user.aboutMe
        self.businessName = user.businessName
        self.licenseNumber = user.licenseNumber
        self.profilePic = user.profilePic
        self.latitude = user.latitude
        self.longitude = user.longitude
        self.status = user.status
        self.access = user.access
        self.lastLogin = user.lastLogin
        self.registerComplete = user.registerComplete
        self.online = user.online
        self.verified = user.verified
    }
    open func encode(with aCoder: NSCoder) {
        aCoder.encode(onlineAddress, forKey: "onlineAddress")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(fullName, forKey: "fullName")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(mobile, forKey: "mobile")
        aCoder.encode(gender, forKey: "gender")
        aCoder.encode(dob, forKey: "dob")
        aCoder.encode(country, forKey: "country")
        aCoder.encode(city, forKey: "city")
        aCoder.encode(professionalExperience, forKey: "professionalExperience")
        aCoder.encode(phoneNumber, forKey: "phoneNumber")
        aCoder.encode(websiteLink, forKey: "websiteLink")
        aCoder.encode(aboutMe, forKey: "aboutMe")
        aCoder.encode(businessName, forKey: "businessName")
        aCoder.encode(licenseNumber, forKey: "licenseNumber")
        aCoder.encode(profilePic, forKey: "profilePic")
        aCoder.encode(latitude, forKey: "latitude")
        aCoder.encode(longitude, forKey: "longitude")
        aCoder.encode(status, forKey: "status")
        aCoder.encode(access, forKey: "access")
        aCoder.encode(lastLogin, forKey: "lastLogin")
        aCoder.encode(registerComplete, forKey: "registerComplete")
        aCoder.encode(online, forKey: "online")
        aCoder.encode(verified, forKey: "verified")
    }
    public required init?(coder aDecoder: NSCoder) {
        country_code = aDecoder.decodeObject(forKey: "country_code") as? String
        onlineAddress = aDecoder.decodeObject(forKey: "onlineAddress") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        fullName = aDecoder.decodeObject(forKey: "fullName") as! String
        state = aDecoder.decodeObject(forKey: "state") as! String
        email = aDecoder.decodeObject(forKey: "email") as! String
        mobile = aDecoder.decodeObject(forKey: "mobile") as! String
        gender = aDecoder.decodeObject(forKey: "gender") as! String
        dob = aDecoder.decodeObject(forKey: "dob") as! String
        country = aDecoder.decodeObject(forKey: "country") as! String
        city = aDecoder.decodeObject(forKey: "city") as! String
        professionalExperience = aDecoder.decodeObject(forKey: "professionalExperience") as! String
        phoneNumber = aDecoder.decodeObject(forKey: "phoneNumber") as! String
        websiteLink = aDecoder.decodeObject(forKey: "websiteLink") as! String
        aboutMe = aDecoder.decodeObject(forKey: "aboutMe") as! String
        businessName = aDecoder.decodeObject(forKey: "businessName") as! String
        licenseNumber = aDecoder.decodeObject(forKey: "licenseNumber") as! String
        profilePic = aDecoder.decodeObject(forKey: "profilePic") as! String
        latitude = aDecoder.decodeObject(forKey: "latitude") as! String
        longitude = aDecoder.decodeObject(forKey: "longitude") as! String
        status = aDecoder.decodeObject(forKey: "status") as! String
        access = aDecoder.decodeObject(forKey: "access") as! String
        lastLogin = aDecoder.decodeObject(forKey: "lastLogin") as! String
        registerComplete = aDecoder.decodeObject(forKey: "registerComplete") as? String
        online = aDecoder.decodeObject(forKey: "online") as? String
        verified = aDecoder.decodeObject(forKey: "verified") as? String
    }

    class public func archivePeople(_ people: UserInfo) -> NSData? {
        do {
            let archivedObject = try NSKeyedArchiver.archivedData(withRootObject: people, requiringSecureCoding: false)
            return archivedObject as NSData
        } catch let error {
            return nil
        }
    }
    class public func retrievePeople(_ data: NSData) -> UserInfo? {
        print("data-\(data)-")
        do {
            let unarc = NSKeyedUnarchiver(forReadingWith: data as Data)
            let newBlog = unarc.decodeObject(forKey: "root") as? UserInfo
            return nil
        } catch let error {
            return nil
        }
    }
    class public func save (_ obb: UserInfo) {
        let defaults = UserDefaults.standard
        defaults.set(archivePeople(obb), forKey: "LoginInfo")
        defaults.synchronize()
    }
    public func save () {
        UserInfo.save(self)
    }
    public class func logout () {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "LoginInfo")
        defaults.synchronize()
    }
    open class func user1() -> Any? {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "LoginInfo") != nil {
            let data = defaults.object(forKey: "LoginInfo") as! NSData
            return retrievePeople(data)
        } else {
            return nil
        }
    }
    open func user() ->  Any? {
        return UserInfo.user1()
    }
}

class Status : Decodable {
    var data: UserInfo?
    var message: String?
    var status: Int?
}





//MARK: TapATradie -- Model
class TapATradie_UserInfo: NSObject, Codable, NSCoding {
    let id: Int?
    let fullName, email, mobile, gender: String?
    let dob, country, city, country_code, professionalExperience: String?
    let phoneNumber, websiteLink, aboutMe, businessName: String?
    let licenseNumber, profilePic, latitude, longitude: String?
    let status, access, lastLogin: String?
    let registerComplete, online, verified: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case email, mobile, gender, dob, country_code, country, city
        case professionalExperience = "professional_experience"
        case phoneNumber = "phone_number"
        case websiteLink = "website_link"
        case aboutMe = "about_me"
        case businessName = "business_name"
        case licenseNumber = "license_number"
        case profilePic = "profile_pic"
        case latitude, longitude, status, access
        case lastLogin = "last_login"
        case registerComplete = "register_complete"
        case online, verified
    }

    public init(_ user: TapATradie_UserInfo) {
        self.country_code = user.country_code
        self.id = user.id
        self.fullName = user.fullName
        self.email = user.email
        self.mobile = user.mobile
        self.gender = user.gender
        self.dob = user.dob
        self.country = user.country
        self.city = user.city
        self.professionalExperience = user.professionalExperience
        self.phoneNumber = user.phoneNumber
        self.websiteLink = user.websiteLink
        self.aboutMe = user.aboutMe
        self.businessName = user.businessName
        self.licenseNumber = user.licenseNumber
        self.profilePic = user.profilePic
        self.latitude = user.latitude
        self.longitude = user.longitude
        self.status = user.status
        self.access = user.access
        self.lastLogin = user.lastLogin
        self.registerComplete = user.registerComplete
        self.online = user.online
        self.verified = user.verified
    }
    open func encode(with aCoder: NSCoder) {
        aCoder.encode(country_code, forKey: "country_code")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(fullName, forKey: "fullName")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(mobile, forKey: "mobile")
        aCoder.encode(gender, forKey: "gender")
        aCoder.encode(dob, forKey: "dob")
        aCoder.encode(country, forKey: "country")
        aCoder.encode(city, forKey: "city")
        aCoder.encode(professionalExperience, forKey: "professionalExperience")
        aCoder.encode(phoneNumber, forKey: "phoneNumber")
        aCoder.encode(websiteLink, forKey: "websiteLink")
        aCoder.encode(aboutMe, forKey: "aboutMe")
        aCoder.encode(businessName, forKey: "businessName")
        aCoder.encode(licenseNumber, forKey: "licenseNumber")
        aCoder.encode(profilePic, forKey: "profilePic")
        aCoder.encode(latitude, forKey: "latitude")
        aCoder.encode(longitude, forKey: "longitude")
        aCoder.encode(status, forKey: "status")
        aCoder.encode(access, forKey: "access")
        aCoder.encode(lastLogin, forKey: "lastLogin")
        aCoder.encode(registerComplete, forKey: "registerComplete")
        aCoder.encode(online, forKey: "online")
        aCoder.encode(verified, forKey: "verified")
    }
    public required init?(coder aDecoder: NSCoder) {
        country_code = aDecoder.decodeObject(forKey: "country_code") as! String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        fullName = aDecoder.decodeObject(forKey: "fullName") as! String
        email = aDecoder.decodeObject(forKey: "email") as! String
        mobile = aDecoder.decodeObject(forKey: "mobile") as! String
        gender = aDecoder.decodeObject(forKey: "gender") as! String
        dob = aDecoder.decodeObject(forKey: "dob") as! String
        country = aDecoder.decodeObject(forKey: "country") as! String
        city = aDecoder.decodeObject(forKey: "city") as! String
        professionalExperience = aDecoder.decodeObject(forKey: "professionalExperience") as! String
        phoneNumber = aDecoder.decodeObject(forKey: "phoneNumber") as! String
        websiteLink = aDecoder.decodeObject(forKey: "websiteLink") as! String
        aboutMe = aDecoder.decodeObject(forKey: "aboutMe") as! String
        businessName = aDecoder.decodeObject(forKey: "businessName") as! String
        licenseNumber = aDecoder.decodeObject(forKey: "licenseNumber") as! String
        profilePic = aDecoder.decodeObject(forKey: "profilePic") as! String
        latitude = aDecoder.decodeObject(forKey: "latitude") as! String
        longitude = aDecoder.decodeObject(forKey: "longitude") as! String
        status = aDecoder.decodeObject(forKey: "status") as! String
        access = aDecoder.decodeObject(forKey: "access") as! String
        lastLogin = aDecoder.decodeObject(forKey: "lastLogin") as! String
        registerComplete = aDecoder.decodeObject(forKey: "registerComplete") as? Int
        online = aDecoder.decodeObject(forKey: "online") as? Int
        verified = aDecoder.decodeObject(forKey: "verified") as? Int
    }
    
    class public func archivePeople(_ people: TapATradie_UserInfo) -> NSData? {
        do {
            let archivedObject = try NSKeyedArchiver.archivedData(withRootObject: people, requiringSecureCoding: false)
            return archivedObject as NSData
        } catch let error {
            return nil
        }
    }
    class public func retrievePeople(_ data: NSData) -> TapATradie_UserInfo? {
        print("data-\(data)-")
        do {
            let unarc = NSKeyedUnarchiver(forReadingWith: data as Data)
            let newBlog = unarc.decodeObject(forKey: "root") as? TapATradie_UserInfo
            return nil
        } catch let error {
            return nil
        }
    }
    class public func save (_ obb: TapATradie_UserInfo) {
        let defaults = UserDefaults.standard
        defaults.set(archivePeople(obb), forKey: "LoginInfo")
        defaults.synchronize()
    }
    public func save () {
        TapATradie_UserInfo.save(self)
    }
    public class func logout () {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "LoginInfo")
        defaults.synchronize()
    }
    open class func user1() -> Any? {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "LoginInfo") != nil {
            let data = defaults.object(forKey: "LoginInfo") as! NSData
            return retrievePeople(data)
        } else {
            return nil
        }
    }
    open func user() ->  Any? {
        return TapATradie_UserInfo.user1()
    }
}

class TapATradie_Status : Decodable {
    var data: TapATradie_UserInfo?
    var message: String?
    var status: Int?
}

