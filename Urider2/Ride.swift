//
//  Ride.swift
//  Urider2
//
//  Created by Duncan Lee on 1/6/17.
//  Copyright © 2017 Duncan Lee. All rights reserved.
//

import Foundation
import UIKit

class Ride: NSObject {
    
    var date: String?
    var destination: String?
    var time: String?
    var timeCreated: String?
    var origin: String?
    var message: String?
    var author : String?
    var key: String?
    
    var isPassenger: Bool?
    var oneWay: Bool?
    var nonSmoking: Bool?
    var petsProhibited: Bool?
    
    var seats: Int?
    var seatsTaken: Int?
    
}
