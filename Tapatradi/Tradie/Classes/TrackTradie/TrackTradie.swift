//
//  TrackTradie.swift
//  Tradie
//
//  Created by Apple on 22/05/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import MapKit

class TrackTradie: UIViewController {
    
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var map: MKMapView!
    
    var leads: Leads?
    
    var providerLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Check")
        DispatchQueue.main.async {
            self.obMoveAnnotation = MoveAnnotation(self.map)
            self.obMoveAnnotation.start()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.obMoveAnnotation.map = nil
            self.obMoveAnnotation = nil
            self.boolSendingLocation = false
            self.boolMapTrackingActive = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            if self.leads != nil {
                let lat = CLLocationDegrees(self.leads!.latitude)
                let lng = CLLocationDegrees(self.leads!.longitude)
                
                if lat != nil && lng != nil {
                    let loc = CLLocationCoordinate2D(latitude: lat!, longitude: lng!)
                    
                    self.providerLocation = CLLocation(latitude: lat!, longitude: lng!)
                    
                    let ano = MyAnnotation(title: self.leads!.address, coordinate: loc, isDriver:true, id:"")
                    ano.uiimage = #imageLiteral(resourceName: "Group 3563")
                    self.map.addAnnotation(ano)
                }
            }
            self.startLocationTracking()
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.map.showAnnotations(self.map.annotations, animated: true)
        }
    }
    
    //MARK: - Live Tracking
    
    var boolSendingLocation = false
    
    var obMoveAnnotation:MoveAnnotation!
    
    var boolShowAnnotation = false
    var countAno = 0
    
    var uiimageOthers: UIImage?
    
    var urlTradiePicture = ""
    
    var boolAnno = 0
    
    var boolRouteDraw = false
    
    func showAnnotations () {
        let arr = self.map.annotations
        
        if arr.count == 2 {
            if boolShowAnnotation == false {
                boolShowAnnotation = true
                self.map.showAnnotations(arr, animated: true)
            }
            
            countAno += 1
            
            if countAno >= 15 {
                boolShowAnnotation = false
                countAno = 0
            }
        }
    }
    
    var boolMapTrackingActive = true
}

extension TrackTradie: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MyAnnotation) {
            return nil
        }
        
        let reuseId = "testwithIdentifier"
        
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            
            anView!.canShowCallout = true
        } else {
            anView!.annotation = annotation
        }
        
        let cpa = annotation as! MyAnnotation
        anView!.image = cpa.uiimage
        
        return anView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.hexColor(0xF7941D)
            polylineRenderer.lineWidth = 3
            return polylineRenderer
        }
        
        return MKOverlayRenderer()
    }
    
    func drawRoute (_ lat: CLLocationDegrees, _ lng: CLLocationDegrees) {        
        let receiverLocation = CLLocation(latitude: lat, longitude: lng)
        
        let ob = PolilineObject(GOOGLE_KEY)
        if providerLocation != nil {
            ob.ll2 = providerLocation!
        }
        ob.ll1 = receiverLocation
        ob.aii = false
        ob.popup = false
        ob.prnt = false
        ob.key = GOOGLE_KEY
        
        //print("Date-\(Date().getStringDate("hh:mm:ss.SSS z"))-")
        
        Map().polyline(ob) { (polys, line1, distance1, ma1, timeSec1, line51, line61, pt1) in
            print("Date-\(Date())-\n---------------------------------------")
            DispatchQueue.main.async {
                var dist: CLLocationDistance = 0
                var time: TimeInterval = 0
                
                self.map.removeOverlays(self.map.overlays)
                
                var pointForReceiver = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                var lastDis:CLLocationDistance = -1
                if self.boolMapTrackingActive && polys != nil {
                    let count = polys?.count
                    
                    for route in polys! {
                        dist += route.distance
                        time += route.expectedTravelTime
                        
                        print("-\(route.distance)-\(route.expectedTravelTime)-")
                        
                        let pointCount = route.polyline.pointCount
                        
                        let coords = UnsafeMutablePointer<CLLocationCoordinate2D>.allocate(capacity: pointCount)
                        
                        route.polyline.getCoordinates(coords, range: NSRange(location: 0, length: pointCount))
                        
                        for m in 0..<pointCount {
                            let point = coords[m]
                            
                            let distance = CLLocation(latitude: lat, longitude: lng).distance(from: CLLocation(latitude: point.latitude, longitude: point.longitude))
                            
                            if lastDis == -1 {
                                lastDis = distance
                                
                                pointForReceiver = point
                            } else if lastDis > distance {
                                lastDis = distance
                                
                                pointForReceiver = point
                            }
                        }
                        
                        self.map.addOverlay(route.polyline)
                    }
                }
                
                if self.obMoveAnnotation != nil {
                    if self.obMoveAnnotation.ano != nil {
                        if self.providerLocation != nil {
                            self.obMoveAnnotation.loc_provider = self.providerLocation!
                        }
                        
                        self.obMoveAnnotation.addNewLocation(pointForReceiver)
                    }
                }
                
                self.showAnnotations ()
            }

        }
    }
}

//MARK: - Live Tracking

extension TrackTradie {
    func setReceiverImageAndMove (_ image: UIImage, _ lat: CLLocationDegrees, _ lng: CLLocationDegrees) {
        let loc = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        
        if obMoveAnnotation != nil {
            if obMoveAnnotation.ano == nil {
                let ano = MyAnnotation(title: (leads?.fullName ?? "").capFirstLetter(), coordinate: loc, isDriver:true, id:"")
                
                ano.uiimage = image
                
                ano.isAnimatingPins = true
                map.addAnnotation(ano)
                
                obMoveAnnotation.ano = ano
                
                obMoveAnnotation.addNewLocation(loc)
                
                self.showAnnotations ()
            }
        }
        
        /*if obMoveAnnotation != nil {
            if obMoveAnnotation.ano != nil {
                if providerLocation != nil {
                    obMoveAnnotation.loc_provider = providerLocation!
                }
                
                obMoveAnnotation.addNewLocation(loc)
            }
        }*/
    }
    
    
    func showLocation (_ lat: CLLocationDegrees, _ lng: CLLocationDegrees) {
        DispatchQueue.main.async {
            self.drawRoute(lat, lng)
            var img: UIImage = #imageLiteral(resourceName: "Group 2885")
            if self.leads?.serviceName != nil {
                if (self.leads?.serviceName)!.count > 0 {
                    img = getMapPin((self.leads?.serviceName ?? ""))
                }
            }
            self.setReceiverImageAndMove(img, lat, lng)
            return
        }
    }
    
    func startSharing () {
        while boolSendingLocation {
            DispatchQueue.global().async {
                kAppDelegate.locationManager?.startUpdatingLocation()
                
                if kAppDelegate.locationManager != nil {
                    let lat = kAppDelegate.locationManager?.location?.coordinate.latitude
                    let lng = kAppDelegate.locationManager?.location?.coordinate.longitude
                    
                    if lat != nil && lng != nil {
                        if lat != 0.0 && lng != 0.0 {
                            self.showLocation(lat!, lng!)
                        }
                    }
                }
            }
            usleep(useconds_t(sleepTime))
        }
    }
    
    func startLocationTracking () {
        boolSendingLocation = true
        DispatchQueue.global().async {
            self.startSharing()
        }
    }
}
