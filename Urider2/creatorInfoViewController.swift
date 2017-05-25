//
//  creatorInfoViewController.swift
//  Urider2
//
//  Created by Duncan Lee on 5/24/17.
//  Copyright © 2017 Duncan Lee. All rights reserved.
//

import UIKit

class creatorInfoViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var ride: Ride!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(ride.creatorName!)
        
        nameLabel.text = ride.creatorName
        emailLabel.text = ride.creatorEmail
        phoneNumberLabel.text = PhoneNumberFormate(str : NSMutableString(string: ride.creatorNumber!))

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func PhoneNumberFormate( str : NSMutableString)->String{
        str.insert("(", at: 0)
        str.insert(") ", at: 4)
        str.insert("-", at: 9)
        return str as String
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
