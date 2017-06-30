//
//  Country.swift
//  MapBorder
//
//  Created by Alfredo Fernandes on 2017-06-29.
//  Copyright © 2017 Alfredo Fernandes. All rights reserved.
//

import Foundation

class Country {
    
    public private(set) var countryName: String
    public private(set) var countrycapital: String
    public private(set) var latitude: Double
    public private(set) var longitude: Double
    
    init(name: String, cap: String, lat: Double, long: Double) {
        self.countryName = name
        self.countrycapital = cap
        self.latitude = lat
        self.longitude = long
    }
}
