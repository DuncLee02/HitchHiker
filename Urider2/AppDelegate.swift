//
//  AppDelegate.swift
//  Urider2
//
//  Created by Duncan Lee on 1/6/17.
//  Copyright © 2017 Duncan Lee. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import GoogleSignIn
import GooglePlaces
import GoogleMaps
//import Google

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FIRApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        
        GMSPlacesClient.provideAPIKey("AIzaSyBzG2AojBz9T4RJh9CnJDVPPM8Ut_Yt9-A")
        GMSServices.provideAPIKey("AIzaSyBzG2AojBz9T4RJh9CnJDVPPM8Ut_Yt9")
        
        //styling navigationbar
        //styling view controller:
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor.white
        navigationBarAppearace.barTintColor = UIColor(colorLiteralRed: 061/255, green: 149/255, blue: 206/255, alpha: 1)
        
        
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        return true
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
//        return GIDSignIn.sharedInstance().handle(url,
//                                                 sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
//                                                 annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        GMSPlacesClient.provideAPIKey("AIzaSyBi2aDSrVnac2xgpPOd4PpH42fJWC6X8mA")
        return true;
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                        sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                annotation: [:])
    //}
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        try! FIRAuth.auth()!.signOut()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //MARK: GIDSignIn Delegate Methods
    
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
        let ref = FIRDatabase.database().reference()
        
        if (userEmail?.hasSuffix(".edu") == false) {
            print("not a school email")
            return;
        }
        
    ref.child("usersDuncan").queryEqual(toValue: userEmail).observe(.value, with: { (snapshot) in
            if (snapshot.exists() == true) {
                print("user has been found")
                //self.performSegue(withIdentifier: "SegueToTable", sender: self)
            }
            else {
                print("new user")
                //self.performSegue(withIdentifier: "SegueToTable", sender: self)
                //self.performSegue(withIdentifier: "segueToUserInfoView", sender: self)
            }
        })
        
    }

}   





