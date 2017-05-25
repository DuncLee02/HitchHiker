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
import FirebaseDatabase

class Ride: NSObject {
    
    var date: String?
    var destination: String?
    var time: String?
    var timeCreated: String?
    var origin: String?
    var message: String?
    var key: String?
    var riders: [Rider]?
    
    var destCoordinates: CLLocationCoordinate2D?
    var origCoordinates: CLLocationCoordinate2D?
    
    var isPassenger: Bool?
    var oneWay: Bool?
    
    var seats: Int?
    var seatsTaken: Int?
    
    var creatorUID: String?
    var author : String?
    var creatorName: String?
    var creatorNumber: String?
    var creatorEmail: String?
    
//    override init(date: String, destination: String, time: String, timeCreated: String, origin: String, message: String, key: String, destCoordinates: String, origCoordinates: String, isPassenger: Bool, oneWay: Bool, seatsTaken: Int, seats: String, creatorUID: String, creatorName: String, creatorNumber: String, creatorEmail: String) {
//        self.date = date
//        self.destination = destination
//        self.origin = origin
//        self.time = time
//        self.timeCreated = timeCreated
//        self.message = message
//        self.key = key
//        
//        self.destCoordinates = destCoordinates
//        self.origCoordinates = origCoordinates
//        
//        self.isPassenger = isPassenger
//        self.oneWay = oneWay
//        
//        self.seatsTaken = seatsTaken
//        self.seats = seats
//        
//    }
    
    override init() {
        
    }
    
    init(rideSnap: FIRDataSnapshot) {
        if let dictionary = rideSnap.value as? [String: AnyObject] {
            self.key = rideSnap.key
            self.date = dictionary["date"] as! String?
            self.destination = dictionary["destination"] as! String?
            self.origin = dictionary["origin"] as! String?
            self.time = dictionary["time"] as! String?
            self.message = dictionary["message"] as! String?
            self.timeCreated = dictionary["timeCreated"] as! String?
            self.creatorUID = dictionary["UID"] as! String?
            
            self.seats = dictionary["seats"] as! Int?
            self.seatsTaken = dictionary["seatsTaken"] as! Int?
            
            self.isPassenger = dictionary["isPassenger"] as! Bool?
            self.oneWay = dictionary["oneWay"] as! Bool?
            
            self.destCoordinates = CLLocationCoordinate2D(latitude: dictionary["destLat"] as! CLLocationDegrees, longitude: dictionary["destLong"] as! CLLocationDegrees)
            self.origCoordinates = CLLocationCoordinate2D(latitude: dictionary["origLat"] as! CLLocationDegrees, longitude: dictionary["origLong"] as! CLLocationDegrees)
            
            self.creatorEmail = dictionary["creatorEmail"] as! String?
            self.creatorName = dictionary["creatorName"] as! String?
            self.creatorNumber = dictionary["creatorNumber"] as! String?
            self.creatorUID = dictionary["creatorUID"] as! String?
            
        }

    }
    
    
}
