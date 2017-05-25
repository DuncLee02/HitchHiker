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

class UserInfoViewController: UIViewController, UITextFieldDelegate {

    
    //GMS SearchBar
    var resultsViewControllerOrigin: GMSAutocompleteResultsViewController!
    var searchControllerOrigin: UISearchController!
    
    var defaultPlace: GMSPlace!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneNumberTextField.delegate = self
        
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
    
    //MARK: Textfield Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let components = (newString as NSString).components(separatedBy: NSCharacterSet.decimalDigits.inverted)
        
        let decimalString = components.joined(separator: "") as NSString
        let length = decimalString.length
        let hasLeadingOne = length > 0 && decimalString.character(at: 0) == (1 as unichar)
        
        if length == 0 || (length > 10 && !hasLeadingOne) || length > 11 {
            let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
            
            return (newLength > 10) ? false : true
        }
        var index = 0 as Int
        let formattedString = NSMutableString()
        
        if hasLeadingOne {
            formattedString.append("1 ")
            index += 1
        }
        if (length - index) > 3 {
            let areaCode = decimalString.substring(with: NSMakeRange(index, 3))
            formattedString.appendFormat("(%@) ", areaCode)
            index += 3
        }
        if length - index > 3 {
            let prefix = decimalString.substring(with: NSMakeRange(index, 3))
            formattedString.appendFormat("%@-", prefix)
            index += 3
        }
        
        let remainder = decimalString.substring(from: index)
        formattedString.append(remainder)
        textField.text = formattedString as String
        return false
    }

    
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        print("next button pressed...")
        if (searchControllerOrigin.searchBar.text == "") {
            print("no destination entered")
            let alertController = UIAlertController(title: "Can't submit", message:
                "no location entered", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        var phoneNumber = "none"
        
        if (phoneNumberTextField.text != "") {
            let onlyNums = phoneNumberTextField.text?.components(separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
            if ((onlyNums?.characters.count)! < 10) {
                print("not a full phone number")
                let alertController = UIAlertController(title: "Can't submit", message:
                    "10 digit phone number required", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            print(onlyNums!)
            phoneNumber = onlyNums!
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
        
        let nameArray = name?.components(separatedBy: " ")
        var capitalizedName = ""
        for components in nameArray! {
            capitalizedName += components.capitalized + " "
        }
        let finalName = capitalizedName.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        
        let dictionary = ["email": userEmail!, "school": school!, "name": finalName, "lat": defaultPlace.coordinate.latitude, "lon": defaultPlace.coordinate.longitude, "defaultName": defaultPlace.name, "phoneNumber": phoneNumber] as [String : Any]
        print(dictionary)
        ref.child("usersDuncan").child(LoginViewController.currentUser.uid).setValue(dictionary)
        LoginViewController.currentUser.phoneNumber = phoneNumber
        LoginViewController.currentUser.email = userEmail!
        LoginViewController.currentUser.name = capitalizedName
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
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        
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


