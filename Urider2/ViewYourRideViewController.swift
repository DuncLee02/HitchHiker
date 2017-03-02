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
    
    
    @IBOutlet weak var EditRideButton: UIButton!
    @IBOutlet weak var DeleteRideButton: UIButton!
    
    var rideBeingViewed: Ride!
    var ref: FIRDatabaseReference!

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
        

        // Do any additional setup after loading the view.
    }

    //MARK: button actions
    

    @IBAction func deleteButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "DELETE", message: "are you sure you'd like to delete your ride?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "yes", style: UIAlertActionStyle.default, handler: {
            (_)in
            alert.dismiss(animated: true, completion: nil)
            self.ref.child("ridesDuncan").child(self.rideBeingViewed.key!).removeValue()
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
            rideInfoVC.riderInfo = rideBeingViewed.riders
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
