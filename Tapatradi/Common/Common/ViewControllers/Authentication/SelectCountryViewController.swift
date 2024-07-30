//
//  SelectCountryViewController.swift
//  Common
//
//  Created by Aman Maharjan on 27/09/2021.
//

import Foundation
import UIKit

public class CountryCell: UITableViewCell {
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var flagImage: UIImageView!
}

public protocol SelectCountryDelegate {
    func selectCountry(didSelect country: Country1)
}

public class SelectCountryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    public var model: [Country1]!
    
    public var delegate: SelectCountryDelegate?
    
    public override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func backdropButton_TouchUpInside(_ sender: UIButton) {
        close()
    }
    
    fileprivate func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension SelectCountryViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let country = model[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell") as! CountryCell
        cell.flagImage.image = CountryFlagService.shared.flag(for: country.iso)
        cell.countryCodeLabel.text = "\(country.niceName) (+\(country.phoneCode))"
        cell.selectionStyle = .none
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let country = model[indexPath.row]
        delegate?.selectCountry(didSelect: country)
        close()
    }
    
}
