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

class SocketIOManager: NSObject {
    
    static let shared = SocketIOManager()
    
    override init() {
        super.init()
    }
    
    let manager = SocketManager(socketURL: URL(string: Server)!, config: [.log(false), .compress])
    
    var boolConnected = false
    
    func login () {
        let id = getUserId ()
        if id != nil {
            let data = ["uid": id!]
            print("socketJoin data-\(data)-")
            self.manager.defaultSocket.emit("socketJoin", data)
        }
    }
    
    func getUserId () -> Any? {
        return Key_User_id.getUserValue()
    }
    
    let maUsers = NSMutableArray()
    
    func create () {
        var socket = manager.defaultSocket
        socket.connect()
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }
        
    }
    
    
    func startSharingLocation () {
        print("startSharingLocation")
        DispatchQueue.global().async {
            self.startSharing()
        }
    }
    
    let semaphore = DispatchSemaphore(value: 1)
    
    func startSharing () {
        print("startSharing-[\(self.maUsers.count)]-")
        semaphore.wait()
        
        while self.maUsers.count > 0 {
            DispatchQueue.global().async {
                kAppDelegate.locationManager?.startUpdatingLocation ()
                //print("kAppDelegate.locationManager-[\(kAppDelegate.locationManager)]-")
                
                if kAppDelegate.locationManager != nil {
                    let lat = kAppDelegate.locationManager?.location?.coordinate.latitude
                    let lng = kAppDelegate.locationManager?.location?.coordinate.longitude
                    
                    print("lat lng-[\(lat)]-[\(lng)]-")
                    
                    if lat != nil && lng != nil {
                        if lat != 0.0 && lng != 0.0 {
                            self.sendLocation(lat!, lng!)
                        }
                    }
                    
                }
            }
            
            usleep(sleepTime)
        }
        
        semaphore.signal()
    }
    
    func sendLocation (_ lat: Double, _ lng: Double) {
        let users = self.maUsers.componentsJoined(by: ",")
        
        if users.count > 0 {
            let id = getUserId ()
            
            if id != nil {
                self.manager.defaultSocket.emit("sendTradieLocationToUser", ["userId": users, "lat": lat, "long": lng, "id": "\(id!)"])
            }
        }
    }
    
    var boolTimerStarted = false
    
    func sendLocationToServer () {
        if boolTimerStarted == false {
            boolTimerStarted = true
            Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(sendLocationToServerTimer), userInfo: nil, repeats: true)
        }
    }
    
    @objc func sendLocationToServerTimer () {
        kAppDelegate.locationManager?.startUpdatingLocation ()
        if kAppDelegate.locationManager != nil {
            let lat = kAppDelegate.locationManager?.location?.coordinate.latitude
            let lng = kAppDelegate.locationManager?.location?.coordinate.longitude
            
            if lat != nil && lng != nil {
                if lat != 0.0 && lng != 0.0 {
                    //self.sendLocation(lat!, lng!)
                    
                    let id = getUserId ()
                    
                    if id != nil {
                        self.manager.defaultSocket.emit("setlocation", ["latitude": lat!, "longitude": lng!, "uid": "\(id!)"])
                    }
                }
            }
        }
    }
}

