//
//  MoveAnnotation.swift
//  Node
//
//  Created by Avinash somani on 20/04/17.
//  Copyright © 2017 Kavyasoftech. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

//let seconds_1 = useconds_t(1000000)
//let seconds = seconds_1 * 2
//let sleepTime = seconds / 1

class TapATradie_MoveAnnotation:NSObject {
    var map: MKMapView!
    var ano:TapATradie_MyAnnotation? = nil
    
    var isAgent = true
    var id:String!
    
    init(_ map: MKMapView) {
        self.map = map
    }
    
    let maPaths = NSMutableArray()
    
    var loc_old:CLLocationCoordinate2D? = nil
    
    func addNewLocation (_ loc:CLLocationCoordinate2D) {
        if loc_old == nil {
            loc_old = loc
        }

        let ob = TapATradie_CalculatePath(loc_last: loc_old!, loc_new: loc)
        
        let obReturn = ob.makePath()
        
        if obReturn.points != nil {
            if (obReturn.points?.count)! > 0 {
                if obReturn.dist > 0.0 {
                    maPaths.add(obReturn)
                }
            }
        }
        
        loc_old = loc
    }
    
    func start () {
        self.performSelector(inBackground: #selector(moveAnnotation), with: nil)
        
        if ano != nil {
            let loc = CLLocationCoordinate2D(latitude: (ano?.coordinate.latitude)!, longitude: (ano?.coordinate.longitude)!)

            addNewLocation(loc)
        }
    }
    
    var indexPath = 0
    var lastIndexPath = 0
    
    var boolMaPath1 = true
    
    @objc func moveAnnotation () {
        DispatchQueue.global().async {
            while (true) {
                var boolWait = true
                
                if self.ano != nil {
                    if self.maPaths.count > 0 {
                        let ob = self.maPaths[0] as? TapATradie_CalculatePathReturn
                        
                        self.maPaths.removeObject(at: 0)
                        
                        if ob != nil {
                            if ob?.points != nil {
                                if (ob?.points?.count)! > 0 {
                                    if (ob?.dist)! > 0.0 {
                                        
                                        boolWait = false
                                        
                                        let sleepFor = Double(sleepTime) / Double((ob?.points?.count)! * 5)
                                        
                                        for i in 0..<Int((ob?.points?.count)!) {
                                            if (ob?.points?.count)! > i {
                                                let loc = CLLocationCoordinate2DMake((ob?.points?[i][0])!, (ob?.points?[i][1])!)
                                                
                                                if loc.latitude != 0.0 && loc.longitude != 0.0 {
                                                    DispatchQueue.global().async {
                                                        self.animateNow (self.ano!, loc, sleepFor)
                                                    }
                                                }
                                            }
                                            
                                            usleep(useconds_t(Int(sleepFor)))
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                if boolWait {
                    usleep(seconds_1)
                }
            }
        }
    }
    
    var lastAnnotationCLLocation:CLLocation? = nil
    var lastDegree = 0
    
    var mycount = 0
    
    func animateNow (_ ano:TapATradie_MyAnnotation, _ point:CLLocationCoordinate2D, _ slee:Double) {
        
        DispatchQueue.main.async {
            /*if self.lastAnnotationCLLocation != nil {
                let location = CLLocation (latitude: point.latitude, longitude: point.longitude)
                
                let degree = self.getBearingBetweenTwoPoints (location, self.lastAnnotationCLLocation!)
                
                ano.annotationView?.transform = CGAffineTransform(rotationAngle: CGFloat(self.degreesToRadians(degree)))
                self.lastAnnotationCLLocation = location
            } else {
                self.lastAnnotationCLLocation = CLLocation (latitude: point.latitude, longitude: point.longitude)
            }*/
            
            ano.coordinate = point
        }
    }
    
    func degreesToRadians(_ degrees: Double) -> Double { return degrees * Double.pi / 180.0 }
    func radiansToDegrees(_ radians: Double) -> Double { return radians * 180.0 / Double.pi }
    
    func getBearingBetweenTwoPoints(_ point1 : CLLocation, _ point2 : CLLocation) -> Double {
        
        let lat1 = degreesToRadians(point1.coordinate.latitude)
        let lon1 = degreesToRadians(point1.coordinate.longitude)
        
        let lat2 = degreesToRadians(point2.coordinate.latitude)
        let lon2 = degreesToRadians(point2.coordinate.longitude)
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        
        let radiansBearing = atan2(y, x)
        
        return radiansToDegrees(radiansBearing)
    }
}

class TapATradie_CalculatePath:NSObject {
    var loc_last:CLLocationCoordinate2D? = nil
    var loc_new:CLLocationCoordinate2D? = nil
    
    init(loc_last:CLLocationCoordinate2D, loc_new:CLLocationCoordinate2D) {
        self.loc_last = loc_last
        self.loc_new = loc_new
    }
    
    var points:[[Double]]? =  nil
    
    func makePath () -> TapATradie_CalculatePathReturn {
        var dist = 0.0
        if loc_last != nil && loc_new != nil {
            
            if (loc_last?.latitude)! != 0.0 && (loc_last?.longitude)! != 0.0 && (loc_new?.latitude)! != 0.0 && (loc_new?.longitude)! != 0.0 {
                let loc1 = CLLocation(latitude: (loc_last?.latitude)!, longitude: (loc_last?.longitude)!)
                let loc2 = CLLocation(latitude: (loc_new?.latitude)!, longitude: (loc_new?.longitude)!)
                
                dist = loc1.distance(from: loc2)
                
                //print("loc1-\(dist)-\(loc1)-")
                
                dist *= 10.0
                
                //print("loc2-\(dist)-\(loc2)-")
                //print("==========================================")
                
                if dist > 0.0 {
                    points = [[Double]](repeating:[Double](repeating:0.0, count:2), count:Int(dist))
                    //print("points-\(points?.count)-")
                    if dist >= 2 {
                        points?[0][0] = loc1.coordinate.latitude
                        points?[0][1] = loc1.coordinate.longitude
                        
                        points?[Int(dist) - 1][0] = loc2.coordinate.latitude
                        points?[Int(dist) - 1][1] = loc2.coordinate.longitude
                    }
                    
                    self.getMiddleLocation(0, Int(dist) - 1, Int(dist))
                }
            }
        }
        
        let ob = TapATradie_CalculatePathReturn()
        ob.points = points
        ob.dist = dist
        
        return ob
    }
    
    func getMiddleLocation (_ pos1:Int,_ pos2:Int,_ size:Int) -> Void {
        
        if (pos1 == pos2) || ((pos1 + 1) == pos2) || (pos1 == (pos2 + 1)) {
            return
        }
        
        let l1 = CLLocationCoordinate2DMake((points?[pos1][0])!, (points?[pos1][1])!)
        let l2 = CLLocationCoordinate2DMake((points?[pos2][0])!, (points?[pos2][1])!)
        
        let middle_point = l1.middleLocationWith(location: l2)
        
        let div = Double((pos1 + pos2) / 2)
        let mod = Int(div * 10.0) % 10
        
        if Int(div) < size {
            points?[Int(div)][0] = middle_point.latitude
            points?[Int(div)][1] = middle_point.longitude
            
            getMiddleLocation (pos1, Int(div), size)
            getMiddleLocation (Int(div), pos2, size)
        }
        
        if mod != 0 {
            let index = Int(div) + 1
            
            if index < size {
                points?[index][0] = middle_point.latitude
                points?[index][1] = middle_point.longitude
                
                getMiddleLocation (pos2, index, size)
            }
        }
    }
}

class TapATradie_CalculatePathReturn {
    var points:[[Double]]? =  nil
    var dist:Double! = 0.0
}

//extension CLLocationCoordinate2D {
//    func middleLocationWith(location:CLLocationCoordinate2D) -> CLLocationCoordinate2D {
//
//        let lon1 = longitude * Double.pi / 180
//        let lon2 = location.longitude * Double.pi / 180
//        let lat1 = latitude * Double.pi / 180
//        let lat2 = location.latitude * Double.pi / 180
//
//        let dLon = lon2 - lon1
//        let x = cos(lat2) * cos(dLon)
//        let y = cos(lat2) * sin(dLon)
//
//        let lat3 = atan2( sin(lat1) + sin(lat2), sqrt((cos(lat1) + x) * (cos(lat1) + x) + y * y) )
//        let lon3 = lon1 + atan2(y, cos(lat1) + x)
//
//        let center:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat3 * 180 / Double.pi, lon3 * 180 / Double.pi)
//        return center
//    }
//}

class TapATradie_MyAnnotation: NSObject, MKAnnotation {
    var title: String?
    dynamic var coordinate: CLLocationCoordinate2D
    var isDriver = false
    var degree:Int! = 0
    var sleepTime:Double! = 0.0
    var isAnimatingPins:Bool!
    var id:String? = nil
    var uiimage:UIImage!
    
    var tradies: TapATradie_Tradies?
    
    init(title: String, coordinate: CLLocationCoordinate2D, isDriver:Bool, id:String) {
        self.title = title
        self.coordinate = coordinate
        self.isDriver = isDriver
        self.id = id
    }
}


