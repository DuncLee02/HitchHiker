//
//  Rider.swift
//  Urider2
//
//  Created by Duncan Lee on 3/24/17.
//  Copyright © 2017 Duncan Lee. All rights reserved.
//

import Foundation

class Rider: NSObject {
    var email: String!
    var uid: String!
    var name: String!
    var number: String!
    
    init(name: String, email: String, uid: String, number: String) {
        self.name = name
        self.email = email
        self.number = number
        self.uid = uid
    }
}


