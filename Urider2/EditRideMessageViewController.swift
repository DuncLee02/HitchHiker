//
//  EditRideMessageViewController.swift
//  Urider2
//
//  Created by Duncan Lee on 1/21/17.
//  Copyright © 2017 Duncan Lee. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class EditRideMessageViewController: UIViewController, UITextViewDelegate {
    
    
    var rideBeingEdited: Ride!
    var rideBeingCreated: Ride!
    
    @IBOutlet weak var messageForRide: UITextView!
    @IBOutlet weak var doneButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(rideBeingEdited)
        doneButton.layer.masksToBounds = true
        doneButton.layer.cornerRadius = 8
        
        messageForRide.delegate = self
        messageForRide.layer.masksToBounds = true
        messageForRide.layer.borderWidth = 4
        messageForRide.layer.cornerRadius = 8
        messageForRide.text = rideBeingEdited.message
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(EditRideMessageViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        rideBeingCreated.message = messageForRide.text
        
        
        var riderDict = [String: Any]()
        for Riders in rideBeingCreated.riders! {
            
            riderDict.updateValue(Riders.email, forKey: Riders.uid)
            
        }
        
        
        let aRideDict = [ "date": rideBeingCreated.date!, "destination": rideBeingCreated.destination!, "isPassenger": rideBeingCreated.isPassenger!, "seats": rideBeingCreated.seats!, "origin": rideBeingCreated.origin!, "time": rideBeingCreated.time!, "oneWay": rideBeingCreated.oneWay!, "message": rideBeingCreated.message!, "seatsTaken": 0, "author": rideBeingCreated.author!, "origLat": rideBeingCreated.origCoordinates!.latitude as Double, "origLong": rideBeingCreated.origCoordinates!.longitude as Double,  "destLat": rideBeingCreated.destCoordinates!.latitude as Double, "destLong": rideBeingCreated.destCoordinates!.longitude as Double, "riders": riderDict, "UID": rideBeingCreated.creatorUID!] as [String : Any]
        
        editRide(RideDict: aRideDict)
        
        let alert = UIAlertController(title: "Ride Submitted!", message: "Your ride has been edited", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            (_)in
            self.performSegue(withIdentifier: "segueFromEditingToYourRides", sender: self)
        })
        
        alert.addAction(OKAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func editRide(RideDict: [String: Any]) {
        print("sending data")
        let ref = FIRDatabase.database().reference()
        
        print(rideBeingEdited.destination!)
        print(rideBeingEdited.key!)
//        //remove old values
//        ref.child("ridesDuncan").child(rideBeingEdited.destination!).child(rideBeingEdited.key!).removeValue()
//        
//        ref.child("ridesDuncan").child(rideBeingEdited.origin!).child(rideBeingEdited.key!).removeValue()
//        
        //insert new values
        ref.child("ridesDuncan").child(rideBeingCreated.origin!).child(rideBeingEdited.key!).setValue(RideDict)
        ref.child("ridesDuncan").child(rideBeingCreated.destination!).child(rideBeingEdited.key!).setValue(RideDict)
        ref.child("userRides").child(LoginViewController.currentUser.uid).child("posted").child(rideBeingEdited.key!).setValue(RideDict)

        
        let index = YourRidesViewController.globalYourRideList.yourRideList.index(of: self.rideBeingEdited)!
        YourRidesViewController.globalYourRideList.yourRideList.remove(at: index)
        YourRidesViewController.globalYourRideList.yourRideList.insert(rideBeingCreated, at: index)
        
        //changes values in all users's acceptedRide List
        for riderItr in rideBeingCreated.riders! {
            ref.child("userRides").child(riderItr.uid).child("accepted").child(self.rideBeingEdited.key!).setValue(RideDict)
        }
        
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
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
