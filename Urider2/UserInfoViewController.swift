//
//  UserInfoViewCellViewController.swift
//  Urider2
//
//  Created by Duncan Lee on 2/8/17.
//  Copyright © 2017 Duncan Lee. All rights reserved.
//

import UIKit
import GooglePlaces
import FirebaseAuth
import FirebaseDatabase

class UserInfoViewController: UIViewController {

    
    //GMS SearchBar
    var resultsViewControllerOrigin: GMSAutocompleteResultsViewController!
    var searchControllerOrigin: UISearchController!
    
    var defaultPlace: GMSPlace!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initialize autocomplete filter:
        let filter = GMSAutocompleteFilter()
        filter.type = GMSPlacesAutocompleteTypeFilter.city
        
        //initialize GMSSearchBar
        resultsViewControllerOrigin = GMSAutocompleteResultsViewController()
        resultsViewControllerOrigin.delegate = self
        resultsViewControllerOrigin.autocompleteFilter = filter    //remove this to allow specific address
        searchControllerOrigin = UISearchController(searchResultsController: resultsViewControllerOrigin)
        searchControllerOrigin.searchBar.placeholder = "enter origin city"
        //searchControllerOrigin.searchBar.prompt = "Origin"
        searchControllerOrigin.searchResultsUpdater = resultsViewControllerOrigin
        
        let subView = UIView(frame: CGRect(x: self.view.frame.midX, y: 63.0, width: view.frame.width, height: 45.0))
        subView.layer.position = CGPoint(x: self.view.frame.midX, y: 140)
        subView.addSubview((searchControllerOrigin.searchBar))
        view.addSubview(subView)
        searchControllerOrigin.searchBar.sizeToFit()
        searchControllerOrigin.hidesNavigationBarDuringPresentation = false

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        if (searchControllerOrigin.searchBar.text == "") {
            print("no destination entered")
            let alertController = UIAlertController(title: "Can't submit", message:
                "no location entered", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        
        //getting school from email
        
        let userEmail = FIRAuth.auth()?.currentUser?.email!
        let name = FIRAuth.auth()?.currentUser?.displayName!
        let ref = FIRDatabase.database().reference()
        
        var indexOfAt = userEmail?.characters.index(of: "@")
        indexOfAt = userEmail?.index(indexOfAt!, offsetBy: 1)
        
        var school = userEmail?.substring(from: indexOfAt!)
        
        //                let indexOfEdu = userEmail?.range(of: ".edu")
        let indexOfEdu = school?.index( (school?.endIndex)! , offsetBy: -4 )
        school = school?.substring(to: (indexOfEdu)!)
        print(school!)
        let dictionary = ["email": userEmail!, "school": school!, "name": name!, "lat": defaultPlace.coordinate.latitude, "lon": defaultPlace.coordinate.longitude, "defaultName": defaultPlace.name] as [String : Any]
        print(dictionary)
        ref.child("usersDuncan").child(LoginViewController.currentUser.uid).setValue(dictionary)
        LoginViewController.currentUser.email = userEmail!
        LoginViewController.currentUser.name = name!
        LoginViewController.currentUser.school = school!
        LoginViewController.currentUser.defaultPlace = defaultPlace.coordinate
        self.performSegue(withIdentifier: "segueToMap", sender: self)
        
        
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

extension UserInfoViewController: GMSAutocompleteResultsViewControllerDelegate {
    
    // Handle the user's selection.
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        
        defaultPlace = place
        searchControllerOrigin.searchBar.text = place.formattedAddress
        
        dismiss(animated: true, completion: nil)
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        print("Error: ", error.localizedDescription)
    }
    
    
    
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}


