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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
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
        
        //removed "riders" : ""
        let aRideDict = [ "date": rideToBeAdded.date!, "destination": rideToBeAdded.destination!, "isPassenger": rideToBeAdded.isPassenger!, "seats": rideToBeAdded.seats!, "origin": rideToBeAdded.origin!, "time": rideToBeAdded.time!, "oneWay": rideToBeAdded.oneWay!, "message": rideToBeAdded.message!, "seatsTaken": 0, "author": author!, "origLat": rideToBeAdded.origCoordinates!.latitude as Double, "origLong": rideToBeAdded.origCoordinates!.longitude as Double,  "destLat": rideToBeAdded.destCoordinates!.latitude as Double, "destLong": rideToBeAdded.destCoordinates!.longitude as Double] as [String : Any]
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
    }
    
    func writeToRides(RideDict: [String: Any]) {
        print("sending data")
        let ref = FIRDatabase.database().reference()
        //ref.child("ridesDuncan").childByAutoId().setValue(RideDict)
        
        let email = FIRAuth.auth()?.currentUser?.email
        let uuid = UUID().uuidString
        
        ref.child("ridesDuncan").child(rideToBeAdded.destination!).child(uuid).setValue(RideDict)
        
        ref.child("ridesDuncan").child(rideToBeAdded.origin!).child(uuid).setValue(RideDict)
        
        ref.child("userRides").child(LoginViewController.currentUser.uid).child(uuid).setValue(RideDict)
        
        //checking/adding origin location
        ref.child("locationsDuncan").child(rideToBeAdded.origin!).observeSingleEvent(of: .value, with: { (snapshot) in
            if (snapshot.exists()) {
                print("snapshot found...")
                print(snapshot)
                var number = 0
                if let dictionary = snapshot.value as? [String: AnyObject]  {
                    number = dictionary["numOrig"] as! Int
                ref.child("locationsDuncan").child(self.rideToBeAdded.origin!).child("numOrig").setValue(number + 1)
                }
                else{
                    print("cannot access data...")
                }
            }
            else{
                print("doesn't exist...")
                ref.child("locationsDuncan").child(self.rideToBeAdded.origin!).setValue(["lat": self.rideToBeAdded.origCoordinates?.latitude as AnyObject, "long": self.rideToBeAdded.origCoordinates?.longitude as AnyObject, "numDest": 0 as AnyObject,"numOrig": 1 as AnyObject] as [String: AnyObject])
            }
        })
        
        //checking/adding destination location
        ref.child("locationsDuncan").child(rideToBeAdded.destination!).observeSingleEvent(of: .value, with: { (snapshot) in
            if (snapshot.exists()) {
                print("snapshot found...")
                print(snapshot)
                var number = 0
                if let dictionary = snapshot.value as? [String: AnyObject]  {
                    number = dictionary["numDest"] as! Int
                    ref.child("locationsDuncan").child(self.rideToBeAdded.destination!).child("numDest").setValue(number + 1)
                }
                else{
                    print("cannot access data...")
                }
            }
            else{
                print("doesn't exist...")
                ref.child("locationsDuncan").child(self.rideToBeAdded.destination!).setValue(["lat": self.rideToBeAdded.destCoordinates?.latitude as AnyObject, "long": self.rideToBeAdded.destCoordinates?.longitude as AnyObject, "numDest": 1 as AnyObject, "numOrig": 0 as AnyObject] as [String: AnyObject])
            }
        })
    }

    
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
