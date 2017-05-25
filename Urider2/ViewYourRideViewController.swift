//
//  ViewYourRideViewController.swift
//  Urider2
//
//  Created by Duncan Lee on 1/18/17.
//  Copyright © 2017 Duncan Lee. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewYourRideViewController: UIViewController {
    
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var rideOrRequestLabel: UILabel!
    @IBOutlet weak var backgroundLabel: UILabel!
    @IBOutlet weak var messageAboutRideTextView: UITextView!
    
    @IBOutlet weak var roundTripImage: UIImageView!
    @IBOutlet weak var driverOrPassengerImage: UIImageView!
    
    
    @IBOutlet weak var viewRiderInfoButton: UIButton!
    @IBOutlet weak var EditRideButton: UIButton!
    @IBOutlet weak var DeleteRideButton: UIButton!
    
    var rideBeingViewed: Ride!
    var ref: FIRDatabaseReference!
    var isAcceptedRide: Bool!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        
        backgroundLabel.layer.masksToBounds = true
        backgroundLabel.layer.cornerRadius = 8
        messageAboutRideTextView.layer.masksToBounds = true
        messageAboutRideTextView.layer.borderWidth = 3
        messageAboutRideTextView.layer.cornerRadius = 8
        
        print("loading values from tableviewcontroller...")
        
        
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
        
        if (isAcceptedRide == true) {
            EditRideButton.isHidden = true
            viewRiderInfoButton.setTitle("View Driver Info", for: .normal)
            DeleteRideButton.setTitle("Remove Ride", for: .normal)
        }

        // Do any additional setup after loading the view.
    }
    
    func removeSelfFromRide() {
        
        rideBeingViewed.seatsTaken! -= 1
//        ref.child("ridesDuncan").child(rideBeingViewed.destination!).child(rideBeingViewed.key!).child("riders").child(LoginViewController.currentUser.uid).removeValue()
//        ref.child("ridesDuncan").child(rideBeingViewed.origin!).child(rideBeingViewed.key!).child("riders").child(LoginViewController.currentUser.uid).removeValue()
        
        //remove from rider list
        ref.child("userRides").child(rideBeingViewed.creatorUID!).child("posted").child(rideBeingViewed.key!).child("riders").child(LoginViewController.currentUser.uid).removeValue()
        ref.child("userRides").child(LoginViewController.currentUser.uid).child("accepted").child(rideBeingViewed.key!).removeValue()
        //remove entry in accepted ridelist
        ref.child("usersDuncan").child(rideBeingViewed.creatorUID!).child("accepted").child(rideBeingViewed.key!).removeValue()
        let index = LoginViewController.currentUser.acceptedRideKeys.index(of: rideBeingViewed.key!)
        LoginViewController.currentUser.acceptedRideKeys.remove(at: index!)
        
        //increment/decrement seatstaken
        ref.child("ridesDuncan").child(rideBeingViewed.destination!).child(rideBeingViewed.key!).child("seatsTaken").setValue(rideBeingViewed.seatsTaken)
        ref.child("ridesDuncan").child(rideBeingViewed.origin!).child(rideBeingViewed.key!).child("seatsTaken").setValue(rideBeingViewed.seatsTaken)
        ref.child("userRides").child(rideBeingViewed.creatorUID!).child("posted").child(rideBeingViewed.key!).child("seatsTaken").setValue(rideBeingViewed.seatsTaken)
        
        YourRidesViewController.globalYourRideList.acceptedRideList.remove(at: YourRidesViewController.globalYourRideList.acceptedRideList.index(of: self.rideBeingViewed)!)
        
    }

    //MARK: button actions
    

    @IBAction func deleteButtonPressed(_ sender: Any) {
        
        if (isAcceptedRide == true) {
            
            
            let alert = UIAlertController(title: "Remove", message: "are you sure you'd like to remove yourself from this ride?", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {
                (_)in
                alert.dismiss(animated: true, completion: nil)
                self.removeSelfFromRide()
                _ = self.navigationController?.popViewController(animated: true)
                
            })
            let noAction = UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: {
                (_)in
                alert.dismiss(animated: true, completion: nil)
                print("dismiss alert")
            })
            alert.addAction(yesAction)
            alert.addAction(noAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let alert = UIAlertController(title: "DELETE", message: "are you sure you'd like to delete your ride?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "yes", style: UIAlertActionStyle.default, handler: {
            (_)in
            alert.dismiss(animated: true, completion: nil)
            
            self.ref.child("ridesDuncan").child(self.rideBeingViewed.destination!).child(self.rideBeingViewed.key!).removeValue()
        self.ref.child("ridesDuncan").child(self.rideBeingViewed.origin!).child(self.rideBeingViewed.key!).removeValue()
            
        self.ref.child("userRides").child(LoginViewController.currentUser.uid).child("posted").child(self.rideBeingViewed.key!).removeValue()
            
            //removes all accepted rides
            for Riders in self.rideBeingViewed.riders! {
                self.ref.child("userRides").child(Riders.uid).child("accepted").child(self.rideBeingViewed.key!).removeValue()
                print("removing accepted ride...")
            }
            
//            //decrement city ridecounts
//            for cities in MapViewController.mapViewRideList.cityList {
//                if cities.cityInfo.name == self.rideBeingViewed.origin {
//                    print(self.rideBeingViewed.origin!)
//                    print(cities.cityInfo.numOrig)
//                    self.ref.child("locationsDuncan").child(self.rideBeingViewed.origin!).child("numOrig").setValue(cities.cityInfo.numOrig - 1)
//                }
//                if cities.cityInfo.name == self.rideBeingViewed.destination {
//                    self.ref.child("locationsDuncan").child(self.rideBeingViewed.destination!).child("numDest").setValue(cities.cityInfo.numDest - 1)
//                }
//            }
            
            //removes value from yourRidesList
            YourRidesViewController.globalYourRideList.yourRideList.remove(at: YourRidesViewController.globalYourRideList.yourRideList.index(of: self.rideBeingViewed)!)
            
            self.performSegue(withIdentifier: "unwindSegueToYourRides", sender: self)
            print("back to yourRidesTable")
        })
        let noAction = UIAlertAction(title: "no", style: UIAlertActionStyle.default, handler: {
            (_)in
            alert.dismiss(animated: true, completion: nil)
            print("dismiss alert")
        })
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func viewRiderInfoButtonPressed(_ sender: Any) {
        if (isAcceptedRide == true) {
            self.performSegue(withIdentifier: "segueToDriverInfo", sender: self)
            return
        }
        else {
            self.performSegue(withIdentifier: "segueToViewRiders", sender: self)
        }
    }
    
    
    @IBAction func editButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "segueToEditRide", sender: self)
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: navigation methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueToEditRide") {
            let editRideVC: EditRideViewController = segue.destination as! EditRideViewController
            editRideVC.rideBeingEdited = rideBeingViewed
        }
        
        if (segue.identifier == "segueToViewRiders") {
            let rideInfoVC: riderInfoViewController = segue.destination as! riderInfoViewController
            rideInfoVC.ride = rideBeingViewed
        }
        if (segue.identifier == "segueToDriverInfo") {
            let rideInfoVC: creatorInfoViewController = segue.destination as! creatorInfoViewController
            rideInfoVC.ride = rideBeingViewed
        }
    }
    
    
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
*/
}
