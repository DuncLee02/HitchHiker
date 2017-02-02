//
//  viewRideFromTableViewController.swift
//  Urider2
//
//  Created by Duncan Lee on 1/11/17.
//  Copyright © 2017 Duncan Lee. All rights reserved.
//

import UIKit

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
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    
    @IBOutlet weak var acceptRideButton: UIButton!
    
    
    var rideIndex: Int!
    var rideList: [Ride]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        
        
        //destinationLabel.text =

        // Do any additional setup after loading the view.
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
