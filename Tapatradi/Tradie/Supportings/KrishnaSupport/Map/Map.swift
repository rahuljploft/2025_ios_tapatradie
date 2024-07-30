//
//  Map.swift
//  HarishFrameworkSwift4
//
//  Created by Harish on 11/07/18.
//  Copyright © 2018 Harish. All rights reserved.
//
import UIKit
import MapKit
open class Poly: NSObject {
    var coords: NSMutableArray!
    var count1: Int = 0
    override init() {
        super.init()
    }
}
open class Map: NSObject {
    open class func instance () -> Map {
        return Map()
    }
    
    public func polylineWithEncodedString(_ encodedString: String) -> MKPolyline {
        let bytes = encodedString.utf8CString
        let length = encodedString.lengthOfBytes(using: .utf8)
        var idx = 0
        var count = length / 4
        var coords: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
        var coordIdx = 0
        var latitude = 0.0
        var longitude = 0.0
        while idx < length {
            var byte: Int
            var res: Int = 0
            var shift: Int = 0
            repeat {
                byte = bytes[idx].hashValue - 63
                res |= (byte & 0x1F) << shift
                shift += 5
                idx += 1
            } while (byte >= 0x20)
            let deltaLat = Double(((res % 2) == 1) ? ~(res >> 1) : res >> 1)
            latitude += deltaLat
            shift = 0
            res = 0
            repeat {
                byte = bytes[idx].hashValue - 0x3F
                res |= (byte & 0x1F) << shift
                shift += 5
                idx += 1
            } while (byte >= 0x20)
            let deltaLon = Double(((res % 2) == 1) ? ~(res >> 1) : res >> 1)
            longitude += deltaLon
            let finalLat = latitude * 1E-5
            let finalLon = longitude * 1E-5
            let coord = CLLocationCoordinate2DMake(finalLat, finalLon)
            coords[coordIdx] = coord
            coordIdx += 1
            if coordIdx == count {
                count += 10
            }
        }
        let poly = MKPolyline.init(coordinates: coords, count: coordIdx)
        return poly
    }
    func polylinePointsString(_ encodedString: String) -> Poly? {
        //decodePolyline
        
        let cords = decodePolylineH(encodedString, precision: 1e5)//decodePolyline(encodedString)
        
        if cords == nil {
            return Poly()
        } else {
            let obb = Poly()
            obb.count1 = cords!.count
            //obb.coords = coords
            obb.coords = NSMutableArray(array: cords!)
            return obb
        }
        
        let bytes = encodedString.utf8CString
        let length = encodedString.lengthOfBytes(using: .utf8)
        var idx = 0
        var count = length / 4
        let coords = NSMutableArray()
        var coordIdx = 0
        var latitude = 0.0
        var longitude = 0.0
        while idx < length {
            var byte: Int
            var res: Int = 0
            var shift: Int = 0
            repeat {
                byte = bytes[idx].hashValue - 63
                res |= (byte & 0x1F) << shift
                shift += 5
                idx += 1
            } while (byte >= 0x20)
            let deltaLat = Double(((res % 2) == 1) ? ~(res >> 1) : res >> 1)
            latitude += deltaLat
            shift = 0
            res = 0
            repeat {
                byte = bytes[idx].hashValue - 0x3F
                res |= (byte & 0x1F) << shift
                shift += 5
                idx += 1
            } while (byte >= 0x20)
            let deltaLon = Double(((res % 2) == 1) ? ~(res >> 1) : res >> 1)
            longitude += deltaLon
            let coord = CLLocationCoordinate2DMake(latitude * 1E-5, longitude * 1E-5)
            coords.add(coord)
            coordIdx += 1
            if coordIdx == count {
                count += 10
            }
        }
        let obb = Poly()
        obb.count1 = coordIdx
        obb.coords = coords
        //obb.coords = NSMutableArray(array: decodePolyline(encodedString))
        return obb
    }
    func polylinePointsMA(_ maa: NSMutableArray, _ count: Int) -> MKPolyline {
        let coords = UnsafeMutablePointer<CLLocationCoordinate2D>.allocate(capacity: count)
        var count1 = 0
        var bool = true
        for iii in 0..<maa.count {
            let obb = maa[iii] as? Poly
            for jjj in 0..<Int((obb?.count1)!) {
                if let obb = obb?.coords[jjj] as? CLLocationCoordinate2D {
                    if bool {
                        coords[count1] = obb
                        count1 += 1
                    }
                    if count > 10000 {
                        bool = !bool
                    }
                }
            }
        }
        let line = MKPolyline.init(coordinates: coords, count: count1)
        free(coords)
        return line
    }
    public func polyline (_ polilineObject: PolilineObject,
                          completion: @escaping (MKPolyline?) -> Swift.Void) {
        /*
         *************************************************************
         *************************************************************
         *************************************************************
         *************************************************************
         HOW TO USE CODE FOR ROUTE IN MAP
         DO NOT DELETE IT
         *************************************************************
         *************************************************************
         *************************************************************
         *************************************************************
         func routeBetweenTwoLocation () {
         Map.instance().polyline(l1,l2,googleApiKey,ai: true,popup: true,prnt: false) { (line) in
         if line != nil {
         self.myPolyLinePath = line
         let overlays = self.map.overlays
         self.map.removeOverlays(overlays)
         self.map.add(self.myPolyLinePath)
         }
         }
         }
         func mapView(_ mapView: MKMapView,viewFor annotation: MKAnnotation) -> MKAnnotationView? {
         let ann = MKPinAnnotationView.init(annotation: annotation,reuseIdentifier: "currentloc")
         ann.canShowCallout = true;
         ann.animatesDrop = true;
         return ann;
         }
         var myPolyLinePath: MKPolyline!
         func mapView(_ mapView: MKMapView,rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
         if overlay is MKPolyline {
         let polyLineRender = MKPolylineRenderer(overlay: myPolyLinePath)
         polyLineRender.strokeColor = UIColor.red
         polyLineRender.lineWidth = 2.0
         return polyLineRender
         }
         return MKPolylineRenderer()
         }
         */
        
        var withKey = ""
        if polilineObject.key != nil {
            withKey = "&key=\(polilineObject.key!)"
        }
        //var url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(l1.
        //coordinate.latitude),\(l1.coordinate.longitude)&destination=\(l2.coordinate.latitude
        //),\(l2.coordinate.longitude)&sensor=false&mode=WALKING\(withKey)"
        var url = "https://maps.googleapis.com/maps/api/directions/json?"
        url += "origin=\(polilineObject.ll1.coordinate.latitude),\(polilineObject.ll1.coordinate.longitude)&"
        url += "destination=\(polilineObject.ll2.coordinate.latitude),\(polilineObject.ll2.coordinate.longitude)&"
        url += "sensor=false&"
        url += "mode=WALKING\(withKey)"
        
        Http.instance().json(url, nil, nil, aai: polilineObject.aii, popup: polilineObject.popup, prnt: polilineObject.prnt, nil, nil, sync: false, defaultCalling: true) { (json, para, str, http, data) in
            //Http.instance().json(url, nil, nil, aai: polilineObject.aii, popup: polilineObject.popup,
            //prnt: polilineObject.prnt) { (json, _, _, _) in
            var ggo = true
            if json != nil {
                let json = json as? NSDictionary
                let maa = NSMutableArray()
                if let routes = json!["routes"] as? NSArray {
                    for iii in 0..<routes.count {
                        if let route = routes[iii] as? NSDictionary {
                            if let arr = route["legs"] as? NSArray {
                                for jjj in 0..<arr.count {
                                    if let route1 = arr[jjj] as? NSDictionary {
                                        if let steps = route1["steps"] as? NSArray {
                                            var totalcount: Int = 0
                                            for kkk in 0..<steps.count {
                                                if let route2 = steps[kkk] as? NSDictionary {
                                                    if let overviewPolyline = route2["polyline"] as? NSDictionary {
                                                        if let points = overviewPolyline["points"] as? String {
                                                            let obb = self.polylinePointsString(points)
                                                            maa.add(obb!)
                                                            totalcount += Int((obb?.count1)!)
                                                            if kkk+1 == steps.count {
                                                                let poly = self.polylinePointsMA(maa, totalcount)
                                                                ggo = false
                                                                completion(poly)
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            if ggo {
                completion(nil)
            }
        }
    }
    public func polyline (_ polilineObject: PolilineObject,
                          completion: @escaping ([MKRoute]?, MKPolyline?, Int?, NSMutableArray?, Int?, MKPolyline?, MKPolyline?, CLLocationCoordinate2D?) -> Swift.Void) {
        //Map().polyline(ob) { (line1, distance1, ma1, timeSec1, line51, line61, pt1) in
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: polilineObject.ll1.coordinate, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: polilineObject.ll2.coordinate, addressDictionary: nil))
        request.requestsAlternateRoutes = false
        request.transportType = .automobile
        
        let directions = MKDirections (request: request)
        
        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else {
                completion(nil, nil, 0, nil, 0, nil, nil, nil)
                return
            }
            
            completion (unwrappedResponse.routes, nil, 0, nil, 0, nil, nil, nil)
        }
    }
    public func polylineGoogle (_ polilineObject: PolilineObject,
                          completion: @escaping (MKPolyline?, Int?, NSMutableArray?, Int?, MKPolyline?, MKPolyline?) -> Swift.Void) {
        /*
         *************************************************************
         *************************************************************
         *************************************************************
         *************************************************************
         HOW TO USE CODE FOR ROUTE IN MAP
         DO NOT DELETE IT
         *************************************************************
         *************************************************************
         *************************************************************
         *************************************************************
         func routeBetweenTwoLocation () {
         Map.instance().polyline(l1,l2,googleApiKey,ai: true,popup: true,prnt: false) { (line) in
         if line != nil {
         self.myPolyLinePath = line
         let overlays = self.map.overlays
         self.map.removeOverlays(overlays)
         self.map.add(self.myPolyLinePath)
         }
         }
         }
         func mapView(_ mapView: MKMapView,viewFor annotation: MKAnnotation) -> MKAnnotationView? {
         let ann = MKPinAnnotationView.init(annotation: annotation,reuseIdentifier: "currentloc")
         ann.canShowCallout = true;
         ann.animatesDrop = true;
         return ann;
         }
         var myPolyLinePath: MKPolyline!
         func mapView(_ mapView: MKMapView,rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
         if overlay is MKPolyline {
         let polyLineRender = MKPolylineRenderer(overlay: myPolyLinePath)
         polyLineRender.strokeColor = UIColor.red
         polyLineRender.lineWidth = 2.0
         return polyLineRender
         }
         return MKPolylineRenderer()
         }
         */
        
        var withKey = ""
        if polilineObject.key != nil {
            withKey = "&key=\(polilineObject.key!)"
        }
        //var url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(l1.
        //coordinate.latitude),\(l1.coordinate.longitude)&destination=\(l2.coordinate.latitude
        //),\(l2.coordinate.longitude)&sensor=false&mode=WALKING\(withKey)"
        var url = "https://maps.googleapis.com/maps/api/directions/json?"
        url += "origin=\(polilineObject.ll1.coordinate.latitude),\(polilineObject.ll1.coordinate.longitude)&"
        url += "destination=\(polilineObject.ll2.coordinate.latitude),\(polilineObject.ll2.coordinate.longitude)&"
        url += "sensor=false&"
        url += "mode=WALKING\(withKey)"
        
        Http.instance().json(url, nil, nil, aai: polilineObject.aii, popup: polilineObject.popup, prnt: polilineObject.prnt, nil, nil, sync: false, defaultCalling: true) { (json, para, str, http, data) in
            
            /*Http.instance().json(url, nil, nil, aai: polilineObject.aii, popup: polilineObject.popup,
             prnt: polilineObject.prnt) { (json, _, _) in*/
            var ggo = true
            if json != nil {
                let json = json as? NSDictionary
                let maa = NSMutableArray()
                
                var line1: MKPolyline?
                var line2: MKPolyline?
                
                if let routes = json!["routes"] as? NSArray {
                    for iii in 0..<routes.count {
                        if let route = routes[iii] as? NSDictionary {
                            if let arr = route["legs"] as? NSArray {
                                for jjj in 0..<arr.count {
                                    if let route1 = arr[jjj] as? NSDictionary {
                                        var distanceVal = 0
                                        var durationVal = 0
                                        
                                        if let distance = route1["distance"] as? NSDictionary {
                                            distanceVal = distance.number("value").intValue
                                        }
                                        
                                        if let duration = route1["duration"] as? NSDictionary {
                                            durationVal = duration.number("value").intValue
                                        }
                                        
                                        if let steps = route1["steps"] as? NSArray {
                                            var totalcount: Int = 0
                                            var distance: CLLocationDistance = 0
                                            for kkk in 0..<steps.count {
                                                if let route2 = steps[kkk] as? NSDictionary {
                                                    if let overviewPolyline = route2["polyline"] as? NSDictionary {
                                                        if let points = overviewPolyline["points"] as? String {
                                                            //print("Line points-\(points)-")
                                                            let obb = self.polylinePointsString(points)
                                                            
                                                            for ijk in 0..<(obb?.coords.count)! {
                                                                let ob = obb?.coords![ijk]
                                                                /*}
                                                                 if (obb?.coords.count)! > 0 && maa.count == 1 {
                                                                 let ob = obb?.coords![0]
                                                                 //let ob = obb?.coords![((obb?.coords.count)!-1)] as? CLLocationCoordinate2D*/
                                                                
                                                                if let gg = ob as? CLLocationCoordinate2D {
                                                                    
                                                                    let distance1 = CLLocation(latitude: gg.latitude, longitude: gg.longitude).distance(from: CLLocation(latitude: polilineObject.ll1.coordinate.latitude, longitude: polilineObject.ll1.coordinate.longitude))
                                                                    
                                                                    if line1 == nil {
                                                                        distance = distance1
                                                                        
                                                                        let coords = UnsafeMutablePointer<CLLocationCoordinate2D>.allocate(capacity: 2)
                                                                        
                                                                        coords[0] = gg
                                                                        coords[1] = CLLocationCoordinate2D(latitude: polilineObject.ll1.coordinate.latitude, longitude: polilineObject.ll1.coordinate.longitude)
                                                                        
                                                                        line1 = MKPolyline.init(coordinates: coords, count: 2)
                                                                    } else if distance > distance1 {
                                                                        distance = distance1
                                                                        
                                                                        let coords = UnsafeMutablePointer<CLLocationCoordinate2D>.allocate(capacity: 2)
                                                                        
                                                                        coords[0] = gg
                                                                        coords[1] = CLLocationCoordinate2D(latitude: polilineObject.ll1.coordinate.latitude, longitude: polilineObject.ll1.coordinate.longitude)
                                                                        
                                                                        line1 = MKPolyline.init(coordinates: coords, count: 2)
                                                                    }
                                                                }
                                                            }
                                                            
                                                            maa.add(obb!)
                                                            totalcount += Int((obb?.count1)!)
                                                            
                                                            if kkk+1 == steps.count {
                                                                if (obb?.coords.count)! > 0 {
                                                                    let hh = obb?.coords![((obb?.coords.count)!-1)] as? CLLocationCoordinate2D
                                                                    
                                                                    let coords = UnsafeMutablePointer<CLLocationCoordinate2D>.allocate(capacity: 2)
                                                                    
                                                                    coords[0] = hh!
                                                                    coords[1] = CLLocationCoordinate2D(latitude: polilineObject.ll2.coordinate.latitude, longitude: polilineObject.ll2.coordinate.longitude)
                                                                    line2 = MKPolyline.init(coordinates: coords, count: 2)
                                                                }
                                                                
                                                                let poly = self.polylinePointsMA(maa, totalcount)
                                                                ggo = false
                                                                completion(poly, distanceVal, maa, durationVal, line1, line2)
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            if ggo {
                completion(nil, 0, nil, 0, nil, nil)
            }
        }
    }
}
public class PolilineObject {
    init(_ key: String?) {
        self.key = key
        self.ll1 = CLLocation()
        self.ll2 = CLLocation()
        self.key = nil
        self.aii = false
        self.popup = false
        self.prnt = false
    }
    var ll1: CLLocation!
    var ll2: CLLocation!
    var key: String?
    var aii: Bool
    var popup: Bool
    var prnt: Bool
}
