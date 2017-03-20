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
        let email = FIRAuth.auth()?.currentUser?.email
                
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
        
        if (rideBeingViewed.riders?.contains(email!))! {
            let alert = UIAlertController(title: "Already Accepted", message: "You have already accepted this ride", preferredStyle: .alert)
            let dismissButton = UIAlertAction(title: "dismiss", style: UIAlertActionStyle.default, handler: {
                (_)in
                alert.dismiss(animated: true, completion: nil)
                print("dismiss alert")
            })
            alert.addAction(dismissButton)
            self.present(alert, animated: true, completion: nil)
            return

        }
       
        print("accepting ride...")
        rideBeingViewed.riders?.append(email!)
        if (rideBeingViewed.destination == cityInTable.cityInfo.name) {
            
            for cities in MapViewController.mapViewRideList.cityList {
                if (cities.cityInfo.name == rideBeingViewed.origin) {
                    print("in city \(cities.cityInfo.name)")
                    for rides in cities.rideList {
                        if (rides.key == rideBeingViewed.key) {
                            rides.riders?.append(email!)
                            print("appended")
                            break
                        }
                    }
                }
            }
            
        }
            
        else {
            
            for cities in MapViewController.mapViewRideList.cityList {
                if (cities.cityInfo.name == rideBeingViewed.destination) {
                    print("in city \(cities.cityInfo.name)")
                    for rides in cities.rideList {
                        if (rides.key == rideBeingViewed.key) {
                            rides.riders?.append(email!)
                            print("appended")
                            break
                        }
                    }
                }
            }
            
        }
//        rideBeingViewed.riders
        ref.child("ridesDuncan").child(rideBeingViewed.destination!).child(rideBeingViewed.key!).child("riders").childByAutoId().setValue(email!)
        ref.child("ridesDuncan").child(rideBeingViewed.origin!).child(rideBeingViewed.key!).child("riders").childByAutoId().setValue(email!)
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
