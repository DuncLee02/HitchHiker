//
//  Ride.swift
//  Urider2
//
//  Created by Duncan Lee on 1/6/17.
//  Copyright © 2017 Duncan Lee. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class Ride: NSObject {
    
    var date: String?
    var destination: String?
    var time: String?
    var timeCreated: String?
    var origin: String?
    var message: String?
    var author : String?
    var key: String?
    var riders: [String]?
    
    var destCoordinates: CLLocationCoordinate2D?
    var origCoordinates: CLLocationCoordinate2D?
    
    var isPassenger: Bool?
    var oneWay: Bool?
    
    var seats: Int?
    var seatsTaken: Int?
    
}
