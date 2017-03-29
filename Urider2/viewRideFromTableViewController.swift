//
//  viewRideFromTableViewController.swift
//  Urider2
//
//  Created by Duncan Lee on 1/11/17.
//  Copyright © 2017 Duncan Lee. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class viewRideFromTableViewController: UIViewController {
    
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var rideOrRequestLabel: UILabel!
    @IBOutlet weak var backgroundLabel: UILabel!
    @IBOutlet weak var messageAboutRideTextView: UITextView!

    @IBOutlet weak var driverOrPassengerImage: UIImageView!
    @IBOutlet weak var roundTripImage: UIImageView!
    
    
    @IBOutlet weak var acceptRideButton: UIButton!
    
    var ref: FIRDatabaseReference!

    var rideBeingViewed: Ride!
    var cityInTable: City!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundLabel.layer.masksToBounds = true
        backgroundLabel.layer.cornerRadius = 8
        
        messageAboutRideTextView.layer.masksToBounds = true
        messageAboutRideTextView.layer.borderWidth = 3
        messageAboutRideTextView.layer.cornerRadius = 8
        messageAboutRideTextView.isEditable = false
        
        acceptRideButton.layer.masksToBounds = true
        acceptRideButton.layer.cornerRadius = 8
        acceptRideButton.addTarget(self, action: #selector(viewRideFromTableViewController.acceptRidePressed), for: UIControlEvents.touchUpInside)
        
        print("loading values from tableviewcontroller...")
        
        print("one way: ", rideBeingViewed.oneWay!)
        
        self.messageAboutRideTextView.text = rideBeingViewed.message
        self.dateLabel.text = rideBeingViewed.date
        self.destinationLabel.text = rideBeingViewed.destination
        self.originLabel.text = rideBeingViewed.origin
        self.timeLabel.text = rideBeingViewed.time
        
        if rideBeingViewed.isPassenger == true {
            self.driverOrPassengerImage.image = #imageLiteral(resourceName: "PassengerIcon.png")
            self.rideOrRequestLabel.text = "Request"
            self.acceptRideButton.isHidden = true
        }
            
        else {
            self.driverOrPassengerImage.image = #imageLiteral(resourceName: "steeringWheelIcon.jpeg")
            self.rideOrRequestLabel.text = "Ride"
        }
        
        if rideBeingViewed.oneWay == false {
            self.roundTripImage.image = #imageLiteral(resourceName: "roundTrip.png")
        }

        // Do any additional setup after loading the view.
    }
   
    
    func acceptRidePressed() {
        
        ref = FIRDatabase.database().reference()
        let currentUserUID = LoginViewController.currentUser.uid
                
        if((rideBeingViewed.riders?.count)! >= rideBeingViewed.seats!){
            print("ride is full...")
            let alert = UIAlertController(title: "Ride Full!", message: "All seats are already taken", preferredStyle: .alert)
            let dismissButton = UIAlertAction(title: "dismiss", style: UIAlertActionStyle.default, handler: {
                (_)in
                alert.dismiss(animated: true, completion: nil)
                print("dismiss alert")
            })
            alert.addAction(dismissButton)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
//        var contains = false
//        for riders in rideBeingViewed.riders! {
//            if riders.uid == currentUserUID {
//                contains = true
//            }
//        }
//        
//        if ( contains ) {
//            let alert = UIAlertController(title: "Already Accepted", message: "You have already accepted this ride", preferredStyle: .alert)
//            let dismissButton = UIAlertAction(title: "dismiss", style: UIAlertActionStyle.default, handler: {
//                (_)in
//                alert.dismiss(animated: true, completion: nil)
//                print("dismiss alert")
//            })
//            alert.addAction(dismissButton)
//            self.present(alert, animated: true, completion: nil)
//            return
//
//        }
       
        print("accepting ride...")
        
        let newRider = Rider()
        newRider.email = LoginViewController.currentUser.email
        newRider.uid = LoginViewController.currentUser.uid
        
//        rideBeingViewed.riders?.append(newRider)
//        if (rideBeingViewed.destination == cityInTable.cityInfo.name) {
//            
//            for cities in MapViewController.mapViewRideList.cityList {
//                if (cities.cityInfo.name == rideBeingViewed.origin) {
//                    print("in city \(cities.cityInfo.name)")
//                    for rides in cities.rideList {
//                        if (rides.key == rideBeingViewed.key) {
//                            rides.riders?.append(newRider)
//                            print("appended")
//                            break
//                        }
//                    }
//                }
//            }
//            
//        }
//            
//        else {
//            
//            for cities in MapViewController.mapViewRideList.cityList {
//                if (cities.cityInfo.name == rideBeingViewed.destination) {
//                    print("in city \(cities.cityInfo.name)")
//                    for rides in cities.rideList {
//                        if (rides.key == rideBeingViewed.key) {
//                            rides.riders?.append(newRider)
//                            print("appended")
//                            break
//                        }
//                    }
//                }
//            }
//            
//        }
        
        let alert = UIAlertController(title: "Ride Accepted", message: "", preferredStyle: .alert)
        let dismissButton = UIAlertAction(title: "dismiss", style: UIAlertActionStyle.default, handler: {
            (_)in
            alert.dismiss(animated: true, completion: nil)
            print("dismiss")
        })
        alert.addAction(dismissButton)
        self.present(alert, animated: true, completion: nil)
        
//        rideBeingViewed.riders
//        ref.child("ridesDuncan").child(rideBeingViewed.destination!).child(rideBeingViewed.key!).child("riders").child(LoginViewController.currentUser.uid).setValue(currentUserEmail)
//        ref.child("ridesDuncan").child(rideBeingViewed.origin!).child(rideBeingViewed.key!).child("riders").child(LoginViewController.currentUser.uid).setValue(currentUserEmail)
        
        ref.child("userRides").child(rideBeingViewed.creatorUID!).child("posted").child(rideBeingViewed.key!).child("riders").child(LoginViewController.currentUser.uid).setValue(LoginViewController.currentUser.email)
        
        let aRideDict = [ "date": rideBeingViewed.date!, "destination": rideBeingViewed.destination!, "isPassenger": rideBeingViewed.isPassenger!, "seats": rideBeingViewed.seats!, "origin": rideBeingViewed.origin!, "time": rideBeingViewed.time!, "oneWay": rideBeingViewed.oneWay!, "message": rideBeingViewed.message!, "seatsTaken": 0, "author": rideBeingViewed.author!, "origLat": rideBeingViewed.origCoordinates!.latitude as Double, "origLong": rideBeingViewed.origCoordinates!.longitude as Double,  "destLat": rideBeingViewed.destCoordinates!.latitude as Double, "destLong": rideBeingViewed.destCoordinates!.longitude as Double, "UID": rideBeingViewed.creatorUID!] as [String : Any]
        
        ref.child("userRides").child(LoginViewController.currentUser.uid).child("accepted").child(rideBeingViewed.key!).setValue(aRideDict)
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
