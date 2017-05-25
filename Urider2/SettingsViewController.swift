//
//  SettingsViewController.swift
//  Urider2
//
//  Created by Duncan Lee on 1/17/17.
//  Copyright © 2017 Duncan Lee. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SettingsViewController: UITableViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    //account labels
    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!

    override func viewDidLoad() {
        self.clearsSelectionOnViewWillAppear = true
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        profilePictureView.layer.borderWidth = 1
        profilePictureView.layer.masksToBounds = false
        profilePictureView.layer.borderColor = UIColor.black.cgColor
        profilePictureView.layer.cornerRadius = profilePictureView.frame.height/2
        profilePictureView.clipsToBounds = true
        profilePictureView.image = #imageLiteral(resourceName: "profilePicture.png")
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        if (LoginViewController.currentUser.phoneNumber == "none") {
            numberLabel.text = "add a phone number"
        }
        else {
            print("phone number found")
            numberLabel.text = PhoneNumberFormate(str: NSMutableString(string: LoginViewController.currentUser.phoneNumber))
        }
        
        nameLabel.text = LoginViewController.currentUser.name
        locationLabel.text = LoginViewController.currentUser.defaultName
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func signOutButtonPressed(_ sender: Any) {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            GIDSignIn.sharedInstance().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        print("signed out current user...")
        self.performSegue(withIdentifier: "unwindToLoginSegue", sender: self)
    }
    
    
    
    @IBAction func deleteccountButtonPressed(_ sender: Any) {
    }
    
    
    
    func PhoneNumberFormate( str : NSMutableString)->String{
        str.insert("(", at: 0)
        str.insert(") ", at: 4)
        str.insert("-", at: 9)
        return str as String
    }
    
    @IBAction func unwindToSettings(segue: UIStoryboardSegue) {
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
