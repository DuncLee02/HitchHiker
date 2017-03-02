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
        messageForRide.text = rideBeingCreated.message
        
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector(("dismissKeyboard")))
        self.view.addGestureRecognizer(tapGesture)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        rideBeingCreated.message = messageForRide.text
        
        let author = FIRAuth.auth()?.currentUser?.email!
        
        let aRideDict = [ "date": rideBeingCreated.date!, "destination": rideBeingCreated.destination!, "isPassenger": rideBeingCreated.isPassenger!, "seats": rideBeingCreated.seats!, "origin": rideBeingCreated.origin!, "time": rideBeingCreated.time!, "oneWay": rideBeingCreated.oneWay!, "message": rideBeingCreated.message!, "seatsTaken": 0, "author": author!] as [String : Any]
        
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
        ref.child("ridesDuncan").child(rideBeingEdited.key!).removeValue()
        ref.child("ridesDuncan").childByAutoId().setValue(RideDict)
//        print(RideDict)
        YourRidesViewController.globalYourRideList.yourRideList.remove(at: YourRidesViewController.globalYourRideList.yourRideList.index(of: self.rideBeingEdited)!)
        YourRidesViewController.globalYourRideList.yourRideList.append(self.rideBeingCreated)
        
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
