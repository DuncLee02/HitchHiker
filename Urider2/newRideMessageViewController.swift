//
//  newRideMessageViewController.swift
//  Urider2
//
//  Created by Duncan Lee on 1/13/17.
//  Copyright © 2017 Duncan Lee. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class newRideMessageViewController: UIViewController, UITextViewDelegate {
    
    var rideToBeAdded: Ride!
    
    @IBOutlet weak var messageForRide: UITextView!
    @IBOutlet weak var doneButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print(rideToBeAdded)
        doneButton.layer.masksToBounds = true
        doneButton.layer.cornerRadius = 8
        
        messageForRide.delegate = self
        messageForRide.layer.masksToBounds = true
        messageForRide.layer.borderWidth = 4
        messageForRide.layer.cornerRadius = 8
        
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector(("dismissKeyboard")))
        self.view.addGestureRecognizer(tapGesture)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        rideToBeAdded.message = messageForRide.text
        
        print(FIRAuth.auth()?.currentUser?.email as Any)
        
        let author = FIRAuth.auth()?.currentUser?.email!
        
        
        let aRideDict = [ "date": rideToBeAdded.date!, "destination": rideToBeAdded.destination!, "isPassenger": rideToBeAdded.isPassenger!, "seats": rideToBeAdded.seats!, "origin": rideToBeAdded.origin!, "time": rideToBeAdded.time!, "oneWay": rideToBeAdded.oneWay!, "petsProhibited" : rideToBeAdded.petsProhibited!, "nonSmoking": rideToBeAdded.nonSmoking!, "message": rideToBeAdded.message!, "seatsTaken": 0, "author": author!] as [String : Any]
        print(aRideDict)
        
        writeToRides(RideDict: aRideDict)
        
        let alert = UIAlertController(title: "Ride Submitted!", message: "Thank you for submitting your ride!", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            (_)in
            self.performSegue(withIdentifier: "unwindToNewsTable", sender: self)
        })
        print("data sent")
        alert.addAction(OKAction)
        self.present(alert, animated: true, completion: nil)
        
//        performSegue(withIdentifier: "unwindToNewsTable", sender: self)
        
        
    }
    
    func writeToRides(RideDict: [String: Any]) {
        print("sending data")
        let ref = FIRDatabase.database().reference()
        ref.child("ridesDuncan").childByAutoId().setValue(RideDict)
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
