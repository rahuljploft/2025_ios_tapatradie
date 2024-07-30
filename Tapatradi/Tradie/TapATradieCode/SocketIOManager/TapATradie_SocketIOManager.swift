//
//  SocketManager.swift
//  SocketTest
//
//  Created by Apple on 19/11/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import SocketIO
import CoreLocation

class TapATradie_SocketIOManager: NSObject {
    
    static let shared = TapATradie_SocketIOManager()
    
    override init() {
        super.init()
    }
    
    let manager = SocketManager(socketURL: URL(string: TapATradie_Server)!, config: [.log(true), .compress])
    
    var boolConnected = false
    
    func login () {
        let id = getUserId ()
        
        if id != nil {
            let data = ["uid": id!]
            self.manager.defaultSocket.emit("socketJoin", data)
        }
    }
    
    func getUserId () -> Any? {
        return TapATradie_Key_User_id.TapATradie_getUserValue()
    }
    
    var vcTrackTradie: TapATradie_TrackTradie?
    
    func create () {
        let socket = manager.defaultSocket
        
        socket.onAny { (socketEve) in
            if socketEve.event == "data" ||
                socketEve.event == "connect" ||
                socketEve.event == "joined" ||
                socketEve.event == "error" ||
                socketEve.event == "requestForGetTradieLocation" ||
                socketEve.event == "location_recieve" {
                print("socket-onAny-\(socketEve.event)-")
            }
            
            switch socketEve.event {
            case "reconnect":
                self.boolConnected = false
                break
            case "reconnectAttempt":
                self.boolConnected = false
                break
            case "error":
                self.boolConnected = false
                break
            case "connect":
                self.boolConnected = true
                
                self.login()
                break
            case "joined":
                break
            case "getproviderlocation":
                if self.vcTrackTradie != nil {
                    let arr = socketEve.items
                    
                    if arr != nil {
                        for i in 0..<(arr?.count)! {
                            if let dt = arr![i] as? NSDictionary {
                                let lat = dt.number("lat").doubleValue
                                let long = dt.number("long").doubleValue
                                
                                let id = dt.string("id")
                                
                                self.vcTrackTradie?.showLocation(lat, long, id)
                            }
                            
                            break
                        }
                    }
                }
                break
            default: break
            }
        }
        
        socket.connect()
    }
    
    //MARK: - New Start
    
    func sendRequestForLocationStart (_ tradie_id: String) {
        let id = getUserId ()
        
        if id != nil {
            let data = ["userId": id!, "tradieId": tradie_id, "boolStart": true] as [String : Any]
            print("Data-\(data)-")
            self.manager.defaultSocket.emit("requestForGetTradieLocation", data)
        }
    }
    
    func sendRequestForLocationStop (_ tradie_id: String) {
        let id = getUserId ()
        
        if id != nil {
            let data = ["userId": id!, "tradieId": tradie_id, "boolStart": false] as [String : Any]
            self.manager.defaultSocket.emit("requestForGetTradieLocation", data)
        }
    }
}

