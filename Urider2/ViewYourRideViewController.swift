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
    
    
    
    
    
    @IBOutlet weak var driverOrPassengerImage: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    
    @IBOutlet weak var EditRideButton: UIButton!
    @IBOutlet weak var DeleteRideButton: UIButton!
    
    var rideIndex: Int!
    var rideList: [Ride]!
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
        
        print("non smoking: ", rideList[rideIndex].nonSmoking!)
        print("one way: ", rideList[rideIndex].oneWay!)
        print("pets prohibited: ",rideList[rideIndex].petsProhibited!)
        
        self.messageAboutRideTextView.text = rideList[rideIndex].message
        self.dateLabel.text = rideList[rideIndex].date
        self.destinationLabel.text = rideList[rideIndex].destination
        self.originLabel.text = rideList[rideIndex].origin
        self.timeLabel.text = rideList[rideIndex].time
        
        if rideList[rideIndex].isPassenger == true {
            self.driverOrPassengerImage.image = #imageLiteral(resourceName: "PassengerIcon.png")
            self.rideOrRequestLabel.text = "Request"
        }
        else {
            self.driverOrPassengerImage.image = #imageLiteral(resourceName: "steeringWheelIcon.jpeg")
            self.rideOrRequestLabel.text = "Ride"
        }
        
        if rideList[rideIndex].nonSmoking == true {
            self.image1.image = #imageLiteral(resourceName: "nonsmoking.png")
        }
        
        if rideList[rideIndex].oneWay == false {
            self.image2.image = #imageLiteral(resourceName: "roundTrip.png")
        }
        
        if rideList[rideIndex].petsProhibited == false {
            self.image3.image = #imageLiteral(resourceName: "dogIcon.png")
        }

        // Do any additional setup after loading the view.
    }

    //MARK: button actions
    

    @IBAction func deleteButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "DELETE", message: "are you sure you'd like to delete your ride?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "yes", style: UIAlertActionStyle.default, handler: {
            (_)in
            alert.dismiss(animated: true, completion: nil)
            self.ref.child("ridesDuncan").child(self.rideList[self.rideIndex].key!).removeValue()
            YourRidesViewController.globalYourRideList.yourRideList.remove(at: YourRidesViewController.globalYourRideList.yourRideList.index(of: self.rideList[self.rideIndex])!)
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
            editRideVC.rideBeingEdited = rideList[rideIndex]
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
