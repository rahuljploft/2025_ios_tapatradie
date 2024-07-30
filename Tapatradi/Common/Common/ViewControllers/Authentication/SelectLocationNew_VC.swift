//
//  SelectLocationNew_VC.swift
//  Common
//
//  Created by Admin on 20/02/23.
//

import UIKit
import GooglePlaces
import GoogleMaps

class SelectLocationNew_VC: UIViewController, CLLocationManagerDelegate {

    
    @IBOutlet weak var viewSignuP: UIView!
    @IBOutlet weak var lbl_address: UILabel!
    @IBOutlet weak var btnYourLoaction: UIButton!
    @IBOutlet weak var viewAddress: UIView!
    @IBOutlet weak var actionSignUp: UIButton!
    @IBOutlet weak var btnAnotherLoaction: UIButton!
    
    var getAddressModel: GetAddressModel?
    var residentialSelected = true
    var commercialSelected = true
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var latitudeVal = ""
    var longitudeVal = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        latitudeValNew = ""
        longitudeValNew = ""
        //203C54
        GMSPlacesClient.provideAPIKey("AIzaSyAKBtULxvzVH8VHh5kdWxYrmVlzQ6RgUC8")
        GMSServices.provideAPIKey("AIzaSyAKBtULxvzVH8VHh5kdWxYrmVlzQ6RgUC8")
        
        viewAddress.layer.cornerRadius = 5
        viewAddress.layer.shadowColor = UIColor.darkGray.cgColor
        viewAddress.layer.shadowOffset = .zero
        viewAddress.layer.shadowOpacity = 0.5
        viewAddress.layer.shadowRadius = 2
        actionSignUp.clipsToBounds = true
        actionSignUp.layer.cornerRadius = 17.5
        btnYourLoaction.layer.cornerRadius = 5
        btnAnotherLoaction.layer.cornerRadius = 5
        //viewSignuP.clipsToBounds = true
        //viewSignuP.layer.cornerRadius = 12.5
        viewAddress.isHidden = true
        tabBarColor()
        
        
    }
    
    
    @IBAction func actionSubmit(_ sender: UIButton) {
        if latitudeValNew == "" || longitudeValNew == "" {
            let alert = UIAlertController(title: "Tap A Tradie", message: "Select your service location.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            self.present(alert, animated: true)
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewLeadsScreen_VC") as! NewLeadsScreen_VC
            self.navigationController?.push(viewController: vc,animated: true)
        }
    }
    
    
    @IBAction func actionNext(_ sender: UIButton) {
        loginShowStatus = true
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: LoginViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    @IBAction func actionYourCurrentLocation(_ sender: UIButton) {
        currentLocationGet()
        
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionAnotherLocation(_ sender: Any) {
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
                    
                    latitudeValNew = "\(latitudeVal)"
                    longitudeValNew = "\(longitudeVal)"
                    
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
                    let jsonDict = json as? NSDictionary
                    self.getAddressModel = try! JSONDecoder().decode(GetAddressModel.self, from: data!)
                    DispatchQueue.main.async {
                        self.viewAddress.isHidden = false
                        self.lbl_address.text = self.getAddressModel?.results?[0].formattedAddress ?? ""
                        addressValNew = "\(self.getAddressModel?.results?[0].formattedAddress ?? "")"
                    }
                }
            }
            task.resume()
        }
    }
    
}





extension SelectLocationNew_VC {
    
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

extension SelectLocationNew_VC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        viewAddress.isHidden = false
        lbl_address.text = "\(place.name ?? "")"
        print("Place name: \(place.name ?? "")")
        print("Place ID: \(String(describing: place.placeID))")
        print("Place attributions: \(String(describing: place.attributions))")
        
        latitudeValNew = "\(place.coordinate.latitude)"
        longitudeValNew = "\(place.coordinate.longitude)"
        addressValNew = "\(place.name ?? "")"
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}




