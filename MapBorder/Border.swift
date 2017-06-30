//
//  Border.swift
//  MapBorder
//
//  Created by Alfredo Fernandes on 2017-06-29.
//  Copyright © 2017 Alfredo Fernandes. All rights reserved.
//

import Foundation

class Border {
    
    var country: Country
    var countryborder: [Country]
    
    init(name: String, capital: String, latitude: Double, longitude: Double)
    {
        self.country = Country(name: name, cap: capital, lat: latitude, long: longitude)
        countryborder  = []
    }
    
    init(country: Country) {
        self.country = country
        countryborder  = []
    }
    
    func addBorder(country: Country) {
        countryborder.append(country)
    }
    
    func addBorder(name: String, capital: String, latitude: Double, longitude: Double) {
        countryborder.append(Country(name: name, cap: capital, lat: latitude, long: longitude))
    }
}
