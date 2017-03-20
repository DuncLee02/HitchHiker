//
//  Destination.swift
//  Urider2
//
//  Created by Duncan Lee on 3/14/17.
//  Copyright © 2017 Duncan Lee. All rights reserved.
//

import Foundation
import GoogleMaps

class Destination: NSObject {
    var name: String!
    var rides = 0
    var requests = 0
    var destination: CLLocationCoordinate2D!
    var outgoing = true
}
