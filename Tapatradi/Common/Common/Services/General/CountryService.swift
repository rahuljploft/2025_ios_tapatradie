//
//  CountryCodes.swift
//  Common
//
//  Created by Aman Maharjan on 15/09/2021.
//

import Foundation

public protocol CountryServiceProtocol {
    var asArray: [Country1] { get }
    var asDictionary: [String: Country1] { get }
}

public class CountryService: CountryServiceProtocol {
    
    private var countriesArray = [Country1]()
    private var countriesDictionary = [String: Country1]()
    
    public static var shared = CountryService()
    
    public var asArray: [Country1] { return load() }
    
    public var asDictionary: [String: Country1] { return toDictionary(asArray) }
    
    private init() { }
    
    private func load() -> [Country1] {
        guard let url = Bundle.init(for: Self.self).url(forResource: "Countries", withExtension: "json") else { fatalError("Error: Country list could not be loaded") }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            countriesArray = try decoder.decode([Country1].self, from: data)
            return countriesArray
        } catch {
            fatalError("Error: \(error)")
        }
    }
    
    public func toDictionary(_ countries: [Country1]) -> [String: Country1] {
        guard countriesDictionary.isEmpty else { return countriesDictionary}
        
        print("toDictionary called")
        var result = [String: Country1]()
        for country in countries {
            result[country.iso] = country
        }
        countriesDictionary = result
        return countriesDictionary
    }
}
