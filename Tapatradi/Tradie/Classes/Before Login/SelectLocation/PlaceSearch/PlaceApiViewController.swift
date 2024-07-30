//
//  PlaceApiViewController.swift
//  DialMd
//
//  Created by Nitin on 13/01/17.
//  Copyright © 2017 lms. All rights reserved.
//

import UIKit
import GooglePlaces

protocol PlanceApiDelegate {
    func PlaceApiData(_ ob: Addresses)
}

class PlaceApiViewController: UIViewController, GMSAutocompleteResultsViewControllerDelegate, UISearchBarDelegate , UISearchControllerDelegate {
    
    var delegate: PlanceApiDelegate?
    
    @IBOutlet weak var innerView: UIView!
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    var LocationCityFinaldata : String = ""
    
    var LocationCity1 : String = ""
    var LocationCity : String = ""
    var LocationCountry : String = ""
    @IBOutlet weak var searchBar: UISearchBar!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func language () {
        //changeAppLanguage(self.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //kAppDelegate.getCartCount()
        language ()
    
        kAppDelegate.currentVC = self
    }
    
    override func viewDidLoad() {
                //kAppDelegate.setCurrentVC(self)
        super.viewDidLoad()
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.tableCellBackgroundColor = UIColor.clear
        resultsViewController?.delegate = self
        
        let filter = GMSAutocompleteFilter()
        //filter.type = .address
        //filter.country = "hk"
        
        resultsViewController?.autocompleteFilter = filter
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        searchController?.searchBar.barTintColor = UIColor.white
        searchController?.searchBar.showsCancelButton = false
        
        searchController?.searchBar.delegate = self;
        
        let app = UIApplication.shared
        let height = app.statusBarFrame.size.height
        
        let screenSize: CGRect = UIScreen.main.bounds
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: height))
        self.view.addSubview(myView)
        
        let subView = UIView(frame: CGRect(x: 0, y: 45, width: self.view.frame.size.width, height: self.view.frame.size.height))
        subView.addSubview((searchController?.searchBar)!)
        self.view.addSubview(subView)
        
        searchController?.searchBar.sizeToFit()
        searchController?.searchBar.becomeFirstResponder()
        searchController?.hidesNavigationBarDuringPresentation = false
        
        // When UISearchController presents the results view, present it in
        definesPresentationContext = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationItem.titleView = searchController!.searchBar
        DispatchQueue.main.async(execute: {
            //self.searchController?.hidesNavigationBarDuringPresentation = true
            
            //print("self.searchController?.searchBar-\(self.searchController?.searchBar)-")
            
            self.searchController?.searchBar.becomeFirstResponder()
            self.searchController?.isActive = true
            self.searchController!.searchBar.becomeFirstResponder()
        })
    }
    
    func presentSearchController(searchController: UISearchController) {
        searchController.searchBar.becomeFirstResponder()
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Stop doing the search stuff
        // and clear the text in the search bar
        searchBar.text = ""
        // Hide the cancel button
        // You could also change the position, frame etc of the searchBar
        if searchBar.text == ""{
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // Handle the user's selection.
}

extension PlaceApiViewController {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        let addressComponents1 = place.formattedAddress
//        let addressComponents = place.addressComponents
//        ////print(addressComponents)
//        for component in addressComponents! {
//            if component.type == "city" {
//                //print(component.type)
//                //print(component.name)
//            }
//            if component.type == "country" {
//                //print(component.name)
//                LocationCountry = String(format:"%@",component.name)
//            }
//        }
//
//        var state = ""
//        var country = ""
//
//        if let addressLines = place.addressComponents {
//            // Populate all of the address fields we can find.
//            for field in addressLines {
//                switch field.type {
//
//                case kGMSPlaceTypeAdministrativeAreaLevel2:
//                    let administrative_area_level_2 = field.name
//                    ////print(administrative_area_level_2)
//                    LocationCity = String(format:"%@",administrative_area_level_2)
//                    ////print("LocationCity: \(LocationCity)")
//                    break
//                case kGMSPlaceTypeAdministrativeAreaLevel1:
//                    let administrative_area_level_1 = field.name
//                    ////print(administrative_area_level_2)
//                    state = String(format:"%@",administrative_area_level_1)
//                    ////print("LocationCity: \(LocationCity)")
//                    break
//                case kGMSPlaceTypeCountry:
//                    let administrative_area_level_1 = field.name
//                    ////print(administrative_area_level_2)
//                    country = String(format:"%@",administrative_area_level_1)
//                    ////print("LocationCity: \(LocationCity)")
//                    break
//                default:
//                    //LocationCity = String(format:"%@",field.name)
//
//                    ////print("Type: \(field.type), Name: \(field.name)")
//                    break
//                }
//            }
//        }
//
//        if LocationCity == "city" || LocationCity == "" {
//            if let addressLines1 = place.addressComponents {
//                // Populate all of the address fields we can find.
//                for field in addressLines1 {
//                    switch field.type {
//                    case kGMSPlaceTypeAdministrativeAreaLevel1:
//                        let administrative_area_level_1 = field.name
//                        ////print(administrative_area_level_1)
//                        LocationCity1 = String(format:"%@",administrative_area_level_1)
//                        ////print("LocationCity: \(Locatiovarty)")
//                        break
//                    default:
//                        // LocationCity1 = String(format:"%@",field.name)
//
//                        print("Type: \(field.type), Name: \(field.name)")
//                    }
//                }
//            }
//        }
//
//
//        if LocationCity == "city" || LocationCity == "" {
//            LocationCityFinaldata = LocationCity1
//        } else {
//            LocationCityFinaldata = LocationCity
//        }
//
//        ////print(LocationCityFinaldata)
//        //let newString = LocationCityFinaldata.replacingOccurrences(of: "country", with: " ")
//
//        ////print("LocationCityFinaldata: \(LocationCityFinaldata)")
//
//        //var address = "\(place.name!) \(place.formattedAddress!.replacingOccurrences(of: "\(place.name!)", with: ""))"
//        var address = "\(place.formattedAddress!.replacingOccurrences(of: "\(place.name!)", with: ""))"
//        address = address.replacingOccurrences(of: " , ", with: ", ")
//
//        ////print("address-\(address)-")
//
//        let dictObj = ["lat":"\(place.coordinate.latitude)","long":"\(place.coordinate.longitude)", "PlaceAddress":address , "PlaceName":place.name! , "PlaceCity":LocationCityFinaldata , "PlaceCountry":LocationCountry] as [String : Any]
//
//        //let dictObj = ["lat":"\(place.coordinate.latitude)","long":"\(place.coordinate.longitude)", "PlaceAddress":place.formattedAddress as Any , "PlaceName":place.name , "PlaceCity":LocationCityFinaldata , "PlaceCountry":LocationCountry] as [String : Any]
        
        let ob = Addresses("")
        
        ob.locationName = place.name!
        ob.address = addressComponents1//address
        ob.latitude = "\(place.coordinate.latitude)"
        ob.longitude = "\(place.coordinate.longitude)"
        ob.city = LocationCity
        //ob.state = state
        //ob.country = country
        
        delegate?.PlaceApiData(ob)
        self.dismiss(animated: true, completion: nil)
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        //print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}


class RestaurantAddress {
    var location: CLLocation?
    var address: String?
}
