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


class LoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    struct currentUser {
        static var uid = ""
        static var name = ""
        static var school = ""
        static var email = ""
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
            print("User logged in with google..........")
            print(FIRAuth.auth()?.currentUser?.displayName as Any)
            self.checkUserAgainstDatabase()
        })
//        self.performSegue(withIdentifier: "SegueToTable", sender: self)
    }

    func checkUserAgainstDatabase() {
        let userEmail = FIRAuth.auth()?.currentUser?.email!
        let name = FIRAuth.auth()?.currentUser?.displayName!
        let ref = FIRDatabase.database().reference()
        
        if (userEmail?.hasSuffix(".edu") == false) {
            print("not a school email")
            return;
        }
        
        ref.child("usersDuncan").queryOrdered(byChild: "email").queryEqual(toValue: userEmail).observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            if (snapshot.exists()) {
                for childsnaps in snapshot.children.allObjects as! [FIRDataSnapshot] {
                    print(childsnaps)
                    if let dictionary = childsnaps.value as? [String: AnyObject] {
//                        print(snapshot.key)
                        currentUser.uid = snapshot.key as! String
//                        print(dictionary["school"]!)
                        currentUser.email = dictionary["email"] as! String
                        currentUser.name = dictionary["name"] as! String
                        currentUser.school = dictionary["school"] as! String
                    }
                    else {
                        print("unable to access data...")
                    }
                }
                self.performSegue(withIdentifier: "SegueToTable", sender: self)

            }
            else {
                print("new user")
                //getting school from email
                var indexOfAt = userEmail?.characters.index(of: "@")
                indexOfAt = userEmail?.index(indexOfAt!, offsetBy: 1)
                
                var school = userEmail?.substring(from: indexOfAt!)
                
                //                let indexOfEdu = userEmail?.range(of: ".edu")
                let indexOfEdu = school?.index( (school?.endIndex)! , offsetBy: -4 )
                school = school?.substring(to: (indexOfEdu)!)
                print(school)
                let dictionary = ["email": userEmail!, "school": school!, "name": name!] as [String : Any]
                print(dictionary)
                ref.child("usersDuncan").childByAutoId().setValue(dictionary)
                currentUser.email = userEmail!
                currentUser.name = name!
                currentUser.school = school!
                self.performSegue(withIdentifier: "SegueToTable", sender: self)
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

