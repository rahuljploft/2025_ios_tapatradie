//
//  ChatList_Model.swift
//  Tradie
//
//  Created by Admin on 02/03/23.
//

import Foundation

// MARK: - WelcomeElement
struct ChatListModel: Codable {
    let roomId: String?
    let data: [DataChatList?]
}

// MARK: - Datum
struct DataChatList: Codable {
    let id: Int?
    let roomID: String?
    let receiverID, senderID: Int?
    let message: String?
    let type: String?
    let createdOn: String?
    let isRead: Int?
    let receiverName: String?
    let receiverprofile: String?
    let senderName: String?
    let senderprofile: String?

    enum CodingKeys: String, CodingKey {
        case id
        case roomID = "room_id"
        case receiverID = "receiver_id"
        case senderID = "sender_id"
        case message, type
        case createdOn = "created_on"
        case isRead = "is_read"
        case receiverName = "receiver_name"
        case receiverprofile
        case senderName = "sender_name"
        case senderprofile
    }
}
