//
//  City.swift
//  Urider2
//
//  Created by Duncan Lee on 2/18/17.
//  Copyright © 2017 Duncan Lee. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class CityInfo: NSObject {
    var coordinates: CLLocationCoordinate2D!
    var name: String!
    var numOrig: Int!
    var numDest: Int!
    var rideList: [Ride]!
}
