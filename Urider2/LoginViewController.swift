//
//  ViewController.swift
//  Urider2
//
//  Created by Duncan Lee on 1/6/17.
//  Copyright © 2017 Duncan Lee. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import GoogleSignIn
import GooglePlaces


class LoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    struct currentUser {
        static var uid = ""
        static var name = ""
        static var school = ""
        static var email = ""
        static var defaultPlace: CLLocationCoordinate2D!
        static var defaultName = ""
        static var phoneNumber = ""
        static var acceptedRideKeys = [String]()
        static var photo = UIImage()
    }

    @IBOutlet weak var SignInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().shouldFetchBasicProfile = true

        // Uncomment to automatically sign in the user.
        GIDSignIn.sharedInstance().signInSilently()
        
        // TODO(developer) Configure the sign-in button look/feel
        // ...
        SignInButton.colorScheme = .dark
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        print("Nothing!")
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        

        
        print("logging in...")
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let authentication = user.authentication else { return}
        let credential = FIRGoogleAuthProvider.credential(withIDToken: (authentication.idToken)!, accessToken: (authentication.accessToken)!)
        
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                return
            }
            currentUser.uid = (user?.uid)!
            print("User logged in with google..........")
            print(FIRAuth.auth()?.currentUser?.displayName as Any)
            self.checkUserAgainstDatabase()
        })
    }

    func checkUserAgainstDatabase() {
        let userEmail = FIRAuth.auth()?.currentUser?.email!
        let ref = FIRDatabase.database().reference()
        
        if (userEmail?.hasSuffix(".edu") == false) {
            print(userEmail! + " is not a school email")
            let firebaseAuth = FIRAuth.auth()
            do {
                try firebaseAuth?.signOut()
                GIDSignIn.sharedInstance().signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            return;
        }
        
        ref.child("usersDuncan").child(currentUser.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            if (snapshot.exists()) {
                
                
                let keysnap = snapshot.childSnapshot(forPath: "accepted")
                for children in keysnap.children.allObjects as! [FIRDataSnapshot] {
                    currentUser.acceptedRideKeys.append(children.key)
                    print("accepted ride keys..........")
                    print(children.key)
                }

                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    currentUser.phoneNumber = dictionary["phoneNumber"] as! String
                    currentUser.email = dictionary["email"] as! String
                    currentUser.name = dictionary["name"] as! String
                    currentUser.school = dictionary["school"] as! String
                    let latitude = dictionary["lat"] as! Double
                    let longitude = dictionary["lon"] as! Double
                    currentUser.defaultPlace = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    currentUser.defaultName = dictionary["defaultName"] as! String
                    self.performSegue(withIdentifier: "SegueToTable", sender: self)
                    return
                }
                else {
                    print("unable to access data...")
                }
                self.performSegue(withIdentifier: "segueToUserInfoView", sender: self)
//                for childsnaps in snapshot.children.allObjects as! [FIRDataSnapshot] {
//                    print(childsnaps)
//                    if let dictionary = childsnaps.value as? [String: AnyObject] {
//                        currentUser.email = dictionary["email"] as! String
//                        currentUser.name = dictionary["name"] as! String
//                        currentUser.school = dictionary["school"] as! String
//                    }
//                    else {
//                        print("unable to access data...")
//                    }
//                }
//                self.performSegue(withIdentifier: "SegueToTable", sender: self)

            }
            else {
                print("new user")
                
                self.performSegue(withIdentifier: "segueToUserInfoView", sender: self)
            }
            
        })
    }
    
    
    
     // MARK: - Navigation
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {
        
    }

//     // In a storyboard-based application, you will often want to do a little preparation before navigation
//     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//     // Get the new view controller using segue.destinationViewController.
//     // Pass the selected object to the new view controller.
//     }
    
    
    
    

}

