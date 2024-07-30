//
//  AllowLocationNew_VC.swift
//  Tradie
//
//  Created by Admin on 21/02/23.
//

import UIKit
import GooglePlaces
import GoogleMaps

protocol UpdateAddress {
    func updateAddress(address:String,latitude:String,longitude:String)
}


class AllowLocationNew_VC: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var btnYourLoaction: UIButton!
    @IBOutlet weak var btnAnotherLoaction: UIButton!
    
    var delegate:UpdateAddress!
    
    
    
    var getAddressModel: GetAddressModel?
    var residentialSelected = true
    var commercialSelected = true
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var latitudeVal = ""
    var longitudeVal = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        GMSPlacesClient.provideAPIKey("AIzaSyAKBtULxvzVH8VHh5kdWxYrmVlzQ6RgUC8")
        GMSServices.provideAPIKey("AIzaSyAKBtULxvzVH8VHh5kdWxYrmVlzQ6RgUC8")
        
        btnYourLoaction.clipsToBounds = true
        btnYourLoaction.layer.cornerRadius = 5
        
        btnAnotherLoaction.clipsToBounds = true
        btnAnotherLoaction.layer.cornerRadius = 5
    }
    
    @IBAction func actionClose(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func actionCurrentLocation(_ sender: UIButton) {
        currentLocationGet()
    }
    
    @IBAction func customLocation(_ sender: UIButton) {
        autocompleteClicked()
    }
    
    
    func currentLocationGet() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .denied:
                print("No access")
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                currentLocation = locationManager.location
                if currentLocation != nil {
                    latitudeVal = "\(currentLocation.coordinate.latitude)"
                    longitudeVal = "\(currentLocation.coordinate.longitude)"
                    print("latitudeVal",latitudeVal)
                    print("longitudeVal",longitudeVal)
                    
                    latitudeVal = "\(latitudeVal)"
                    longitudeVal = "\(longitudeVal)"
                    
                    getAddressFromLatLon(latitude: latitudeVal, longitude: longitudeVal)
                }
            case .notDetermined:
                print("notDetermined")
                locationManager.delegate = self
                locationManager.requestWhenInUseAuthorization()
                locationManager.requestLocation()
            case .restricted:
                print("restricted")
            @unknown default:
                print("Access")
            }
        } else {
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
        }
    }
    
    func getAddressFromLatLon(latitude: String, longitude: String) {
        let urlStr = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(latitude),\(longitude)&key=AIzaSyAKBtULxvzVH8VHh5kdWxYrmVlzQ6RgUC8"
        if let url = URL(string: urlStr) {
            print(url)
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.timeoutInterval = 180
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let dataVal = data {
                    let json = try! JSONSerialization.jsonObject(with: dataVal, options: [])
                    print("Response :- \(json)")
                    self.getAddressModel = try! JSONDecoder().decode(GetAddressModel.self, from: data!)
                    DispatchQueue.main.async {
                        self.dismiss(animated: true) {
                            let formateAddress = "\(self.getAddressModel?.results?[0].formattedAddress ?? "")"
                            self.delegate.updateAddress(address: formateAddress, latitude: self.latitudeVal, longitude: self.longitudeVal)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
}





extension AllowLocationNew_VC {
    
    // Present the Autocomplete view controller when the button is pressed.
    func autocompleteClicked() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) | UInt(GMSPlaceField.placeID.rawValue))!
        autocompleteController.placeFields = fields
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        
        autocompleteController.autocompleteFilter = filter
        
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    
}

extension AllowLocationNew_VC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name ?? "")")
        print("Place ID: \(String(describing: place.placeID))")
        print("Place attributions: \(String(describing: place.attributions))")
        print(place)
        //print("latitude : \(place.coordinate.latitude)")
        //print("longitude : \(place.coordinate.longitude)")
        

        
        let placeID = place.placeID ?? ""
        
        
       
        dismiss(animated: true) {
            DispatchQueue.main.async {
                self.dismiss(animated: true) {
                    let formateAddress = "\(place.name ?? "")"
                    
                    self.getLatitudeLongitudeUsing(placeID: placeID,formateAddress: formateAddress)
                    
                    //self.delegate.updateAddress(address: formateAddress, latitude: self.latitudeVal, longitude: self.longitudeVal)
                }
            }
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    
    func getLatitudeLongitudeUsing(placeID:String,formateAddress:String) {
        print(placeID)
        let urlStr = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(placeID)&key=AIzaSyAKBtULxvzVH8VHh5kdWxYrmVlzQ6RgUC8"
        if let url = URL(string: urlStr) {
            print(url)
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.timeoutInterval = 180
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let dataVal = data {
                    let json = try! JSONSerialization.jsonObject(with: dataVal, options: [])
                    print("Response :- \(json)")
                    let latitudeModel = try? JSONDecoder().decode(LatitudeModel.self, from: data!)
                    
                    let ob1 = Addresses("")
                    ob1.latitude = "\(latitudeModel?.result.geometry.location.lat ?? 0)"
                    ob1.longitude = "\(latitudeModel?.result.geometry.location.lng ?? 0)"
                    self.latitudeVal = "\(latitudeModel?.result.geometry.location.lat ?? 0)"
                    self.longitudeVal = "\(latitudeModel?.result.geometry.location.lng ?? 0)"
                    
                    print("\(latitudeModel?.result.geometry.location.lat ?? 0)")
                    print("\(latitudeModel?.result.geometry.location.lng ?? 0)")
                    
                    DispatchQueue.main.async {
                        self.dismiss(animated: true) {
                            self.delegate.updateAddress(address: formateAddress, latitude: self.latitudeVal, longitude: self.longitudeVal)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
}


struct GetAddressModel: Codable {
    let results: [ResultGetAddress]?

    enum CodingKeys: String, CodingKey {
        case results
    }
}


// MARK: - Result
struct ResultGetAddress: Codable {
    let formattedAddress: String?

    enum CodingKeys: String, CodingKey {
        case formattedAddress = "formatted_address"
    }
}


struct LatitudeModel: Codable {
    let result: ResultCheck
    let status: String

    enum CodingKeys: String, CodingKey {
        case result, status
    }
}

// MARK: - Result
struct ResultCheck: Codable {
    let geometry: GeometryCheck

    enum CodingKeys: String, CodingKey {
        case geometry
    }
}

// MARK: - Geometry
struct GeometryCheck: Codable {
    let location: LocationCheck
}

// MARK: - Location
struct LocationCheck: Codable {
    let lat, lng: Double
}

