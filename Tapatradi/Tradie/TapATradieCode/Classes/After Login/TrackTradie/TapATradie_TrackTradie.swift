//
//  TrackTradie.swift
//  TapATradie
//
//  Created by Apple on 01/05/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import MapKit

class TapATradie_TrackTradie: UIViewController {
    @IBAction func actionBack(_ sender: Any) {
        TapATradie_SocketIOManager.shared.sendRequestForLocationStop((jobPost?.providerID)!)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var mapTrackTradie: MKMapView!
    var jobPost: TapATradie_JobPost?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        obMoveAnnotation = TapATradie_MoveAnnotation(mapTrackTradie)
        obMoveAnnotation.start()
        TapATradie_SocketIOManager.shared.vcTrackTradie = self
        mapTrackTradie.delegate = self
        urlTradiePicture = "\(TapATradie_Server)profile/\((jobPost?.providerID)!)/\((jobPost?.profilePic)!)"
        sendRequestForLocation ()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        TapATradie_SocketIOManager.shared.vcTrackTradie = nil
        boolTrackTradie = false
        obMoveAnnotation.map = nil
        obMoveAnnotation = nil
        boolMapTrackingActive = false
    }
    
    var bookings: TapATradie_Bookings?
    var providerLocation: CLLocation?
    

    var annotation1 = CLLocation(latitude: 0.0, longitude: 0.0)
    var annotation2 = CLLocation(latitude: 0.0, longitude: 0.0)
    
    override func viewWillAppear(_ animated: Bool) {
        TapATradie_kAppDelegate.TapATradie_currentVC = self
        
        if bookings != nil {
            let lat = CLLocationDegrees(bookings!.latitude)
            let lng = CLLocationDegrees(bookings!.longitude)
            
            annotation1 = CLLocation(latitude: lat!, longitude: lng!)
            
            if lat != nil && lng != nil {
                let loc = CLLocationCoordinate2D(latitude: lat!, longitude: lng!)
                
                providerLocation = CLLocation(latitude: lat!, longitude: lng!)
                
                let ano = TapATradie_MyAnnotation(title: bookings!.address, coordinate: loc, isDriver:true, id:"")
                ano.uiimage = #imageLiteral(resourceName: "Group 3563-1")
                mapTrackTradie.addAnnotation(ano)
            }
        }
        
        
        if jobPost != nil {
            let lat = CLLocationDegrees(jobPost!.latitude)
            let lng = CLLocationDegrees(jobPost!.longitude)
            
            annotation2 = CLLocation(latitude: lat!, longitude: lng!)
            if lat != nil && lng != nil {
                let loc = CLLocationCoordinate2D(latitude: lat!, longitude: lng!)
                
                providerLocation = CLLocation(latitude: lat!, longitude: lng!)
                
                let ano = TapATradie_MyAnnotation(title: (jobPost?.fullName)!, coordinate: loc, isDriver:true, id:"")
                ano.uiimage = #imageLiteral(resourceName: "Group 3563-1")
                mapTrackTradie.addAnnotation(ano)
            }
        }
        
        
        showRouteOnMap()
        //showLocation(Double(jobPost!.latitude)!, Double(jobPost!.longitude)!, (jobPost?.id)!)
    }
    
    
    
    
    
    func showRouteOnMap() {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: annotation1.coordinate, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: annotation2.coordinate, addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        let directions = MKDirections(request: request)
        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            if (unwrappedResponse.routes.count > 0) {
                var selectedIndex = 0
                var distanceShort = unwrappedResponse.routes[0].distance
                for i in 0..<unwrappedResponse.routes.count {
                    if distanceShort > unwrappedResponse.routes[0].distance{
                        distanceShort = unwrappedResponse.routes[i].distance
                        selectedIndex = i
                    }
                }
                self.mapTrackTradie.addOverlay(unwrappedResponse.routes[selectedIndex].polyline)
                self.mapTrackTradie.setVisibleMapRect(unwrappedResponse.routes[selectedIndex].polyline.boundingMapRect,edgePadding: UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100) , animated: true)
            }
        }
        
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = UIColor.black
        polylineRenderer.lineWidth = 4
        return polylineRenderer
    }
    
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        mapTrackTradie.showAnnotations(mapTrackTradie.annotations, animated: true)
    }
    
    var obMoveAnnotation:TapATradie_MoveAnnotation!
    func setReceiverImageAndMove (_ image: UIImage, _ lat: CLLocationDegrees, _ lng: CLLocationDegrees) {
        let loc = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        if obMoveAnnotation != nil {
            if obMoveAnnotation.ano == nil {
                let ano = TapATradie_MyAnnotation(title: (jobPost?.fullName)!.capFirstLetter(), coordinate: loc, isDriver:true, id:"")
                ano.uiimage = image
                ano.isAnimatingPins = true
                mapTrackTradie.addAnnotation(ano)
                obMoveAnnotation.ano = ano
                obMoveAnnotation.addNewLocation(loc)
                self.showAnnotations ()
            }
        }
        
        // Harish 16-09-2019
        
        /*if obMoveAnnotation != nil {
            if obMoveAnnotation.ano != nil {
                obMoveAnnotation.addNewLocation(loc)
            }
        }*/
    }
    
    var boolAnno = 0
    
    func showAnnotations () {
        let arr = self.mapTrackTradie.annotations
        if arr.count == 2 {
            if boolShowAnnotation == false {
                boolShowAnnotation = true
                self.mapTrackTradie.showAnnotations(arr, animated: true)
            }
            countAno += 1
            if countAno >= 15 {
                boolShowAnnotation = false
                countAno = 0
            }
        }
    }
    
    var boolShowAnnotation = false
    var countAno = 0
    
    var uiimageOthers: UIImage?
    
    var urlTradiePicture = ""
    
    var boolRouteDraw = false
    
    func showLocation (_ lat: CLLocationDegrees, _ lng: CLLocationDegrees, _ id: String) {
        if (jobPost?.providerID)! != id {
            return
        }
        
        //if boolRouteDraw == false {
            drawRoute(lat, lng)
        //}
        
        boolGettingReceiverLocation = true
        
        dateUpdateLocationFromReceiver = Date()
        
        var img: UIImage = #imageLiteral(resourceName: "Group 2885")
        
        if bookings?.serviceName != nil {
            if (bookings?.serviceName)!.count > 0 {
                img = TapATradie_getMapPin((bookings?.serviceName)!)
            }
        }
        
        self.setReceiverImageAndMove(img, lat, lng)
        
        return
    }
    
    var boolGettingReceiverLocation = false
    var boolTrackTradie = true
    var dateUpdateLocationFromReceiver = Date()
    
    var boolMapTrackingActive = true
    
    func sendRequestForLocation () {
        if self.boolGettingReceiverLocation == false {
            TapATradie_SocketIOManager.shared.sendRequestForLocationStart((jobPost?.providerID)!)
        }
        
        DispatchQueue.global().async {
            sleep(10)
            
            if self.boolGettingReceiverLocation == false {
                if self.boolTrackTradie {
                    self.sendRequestForLocation ()
                }
            } else {
                let date = Date()
                
                let comp = date.all(from: self.dateUpdateLocationFromReceiver)
                
                if comp.year! == 0 &&
                    comp.month! == 0 &&
                    comp.day! == 0 &&
                    comp.hour! == 0 && (comp.minute! > 0 || comp.second! >= 30) {
                    self.boolGettingReceiverLocation = false
                }
                
                if self.boolTrackTradie {
                    self.sendRequestForLocation ()
                }
            }
        }
    }
}

extension TapATradie_TrackTradie: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is TapATradie_MyAnnotation) {
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
        
        let cpa = annotation as! TapATradie_MyAnnotation
        var img = cpa.uiimage
        
        let size:CGFloat = 40
        
        img = cpa.uiimage.resize(size)
        
        let sz = img!.size
        
        var rds = sz.height
        
        if sz.width < sz.height {
            rds = sz.width
        }
        
        if img != nil {
            anView!.image = img?.TapATradie_roundedRectImageFromImage(image: img!, imageSize: sz, cornerRadius: rds/2)
        }
        
        return anView
    }
    
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        if overlay is MKPolyline {
//            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
//            polylineRenderer.strokeColor = UIColor.hexColor(0xF7941D)
//            polylineRenderer.lineWidth = 3
//            return polylineRenderer
//        }
//
//        return MKOverlayRenderer()
//    }
    
    func drawRoute (_ lat: CLLocationDegrees, _ lng: CLLocationDegrees) {        
        let receiverLocation = CLLocation(latitude: lat, longitude: lng)
        
        let ob = PolilineObject(GOOGLE_KEY)
        ob.ll2 = providerLocation!
        ob.ll1 = receiverLocation
        ob.aii = false
        ob.popup = false
        ob.prnt = false
        ob.key = GOOGLE_KEY
        
        print("Date-\(Date())-")
        Map().polyline(ob) { (polys, line1, distance1, ma1, timeSec1, line51, line61, pt1) in
            print("Date-\(Date())-\n---------------------------------------")
            
            var dist: CLLocationDistance = 0
            var time: TimeInterval = 0
            
            self.mapTrackTradie.removeOverlays(self.mapTrackTradie.overlays)
            
            var pointForReceiver = CLLocationCoordinate2D(latitude: lat, longitude: lng)

            /*if self.boolMapTrackingActive && polys != nil {
                for route in polys! {
                    self.mapTrackTradie.addOverlay(route.polyline)
                }
            }*/
            
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
                    
                    self.mapTrackTradie.addOverlay(route.polyline)
                }
            }
            
            if self.obMoveAnnotation != nil {
                if self.obMoveAnnotation.ano != nil {
                    self.obMoveAnnotation.addNewLocation(pointForReceiver)
                }
            }
            
            self.showAnnotations ()
        }
    }
}

extension UIImage {
    func TapATradie_roundedRectImageFromImage(image:UIImage, imageSize:CGSize, cornerRadius:CGFloat)->UIImage{
        UIGraphicsBeginImageContextWithOptions(imageSize,false,0.0)
        let bounds=CGRect(origin: CGPoint(x: 0, y: 0), size: imageSize)
        UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).addClip()
        image.draw(in: bounds)
        //image.drawInRect(bounds)
        let finalImage=UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return finalImage!
    }
}
