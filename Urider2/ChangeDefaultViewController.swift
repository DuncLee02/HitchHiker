//
//  ChangeDefaultViewController.swift
//  Urider2
//
//  Created by Duncan Lee on 4/3/17.
//  Copyright © 2017 Duncan Lee. All rights reserved.
//

import UIKit
import GooglePlaces
import FirebaseDatabase

class ChangeDefaultViewController: UIViewController, UISearchControllerDelegate, UITextFieldDelegate {
    
    var newDefaultPlace: GMSPlace!
    var index = 0
    @IBOutlet weak var newValueTextField: UITextField!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var submitChangesButton: UIButton!
    
    
    var resultsViewControllerOrigin: GMSAutocompleteResultsViewController!
    var searchControllerOrigin: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        submitChangesButton.backgroundColor = customBlue()
        if (index == 1) {
            submitChangesButton.titleLabel?.text = "Submit Name"
            typeLabel.text = "Enter New Name"
            self.newValueTextField.becomeFirstResponder()
            return
        }
        if (index == 2) {
            submitChangesButton.titleLabel?.text = "Submit new Number: format 999-999-9999"
            newValueTextField.delegate = self
            typeLabel.text = "Enter a new Number"
            self.newValueTextField.keyboardType = .numberPad
            self.newValueTextField.becomeFirstResponder()
            return
        }
        if (index == 3) {
            submitChangesButton.titleLabel?.text = "Submit New Location"
            typeLabel.text = "Default Location"
            newValueTextField.isHidden = true
            
            //initialize autocomplete filter:
            let filter = GMSAutocompleteFilter()
            filter.type = GMSPlacesAutocompleteTypeFilter.city
            
            //initialize GMSSearchBar
            resultsViewControllerOrigin = GMSAutocompleteResultsViewController()
            resultsViewControllerOrigin.delegate = self
            resultsViewControllerOrigin.autocompleteFilter = filter    //remove this to allow specific address
            searchControllerOrigin = UISearchController(searchResultsController: resultsViewControllerOrigin)
            searchControllerOrigin.isActive = true
            searchControllerOrigin.delegate = self
            searchControllerOrigin.searchResultsUpdater = resultsViewControllerOrigin
            
            let subView = UIView(frame: CGRect(x: self.view.frame.midX, y: 63.0, width: view.frame.width, height: 45.0))
            subView.layer.position = CGPoint(x: self.view.frame.midX, y: 150)
            subView.addSubview((searchControllerOrigin.searchBar))
            view.addSubview(subView)
            searchControllerOrigin.searchBar.sizeToFit()
//            searchControllerOrigin.searchBar.backgroundImage = 
            searchControllerOrigin.hidesNavigationBarDuringPresentation = false
            searchControllerOrigin.searchBar.text = LoginViewController.currentUser.defaultName
            searchControllerOrigin.searchBar.becomeFirstResponder()
            return
        }
        
        self.newValueTextField.becomeFirstResponder()
        
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        if (index == 3) {
            print("making first responder...")
            searchControllerOrigin.isActive = true
            DispatchQueue.main.async {
                self.searchControllerOrigin.searchBar.becomeFirstResponder()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitChangesButtonPressed(_ sender: Any) {
        print("update button pressed")
        if (index == 1) {
            if (newValueTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
                print("no name entered")
                return
            }
            else {
                LoginViewController.currentUser.name = newValueTextField.text!
                let ref = FIRDatabase.database().reference()
                ref.child("usersDuncan").child(LoginViewController.currentUser.uid).child("name").setValue(newValueTextField.text)
            }
        }
        if (index == 2) {
            if (newValueTextField.text == "") {
                print("no number entered")
                return
            }
            let onlyNums = newValueTextField.text?.components(separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
            let length = onlyNums?.characters.count
            if (length! < 10) {
                print("not a full phone number")
                let alertController = UIAlertController(title: "Can't submit", message:
                    "10 digit phone number required", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            LoginViewController.currentUser.phoneNumber = onlyNums!
            let ref = FIRDatabase.database().reference()
            ref.child("usersDuncan").child(LoginViewController.currentUser.uid).child("phoneNumber").setValue(onlyNums)
        }
        if (index == 3) {
            if searchControllerOrigin.searchBar.text == "" {
                print("no value inputted")
                return
            }
            
            LoginViewController.currentUser.defaultName = newDefaultPlace.name
            LoginViewController.currentUser.defaultPlace = newDefaultPlace.coordinate
            
            let ref = FIRDatabase.database().reference()
            ref.child("usersDuncan").child(LoginViewController.currentUser.uid).child("lat").setValue(newDefaultPlace.coordinate.latitude)
            ref.child("usersDuncan").child(LoginViewController.currentUser.uid).child("lon").setValue(newDefaultPlace.coordinate.latitude)
            ref.child("usersDuncan").child(LoginViewController.currentUser.uid).child("defaultName").setValue(newDefaultPlace.name)
        }
        self.performSegue(withIdentifier: "unwindToUserInfo", sender: self)
        return
    }
    
    //MARK: –Colors
    func customEggshellColor() ->UIColor {
        return UIColor(colorLiteralRed: 241/255, green: 233/255, blue: 218/255, alpha: 1)
    }
    
    func customBlue() ->UIColor {
        return UIColor(colorLiteralRed: 125/255, green: 190/255, blue: 242/255, alpha: 1)
    }
    func customGrey() ->UIColor {
        return UIColor(colorLiteralRed: 216/255, green: 215/255, blue: 217/255, alpha: 1)
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    //MARK- PhoneNumber Textfield Delegate
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
    
    
}

extension ChangeDefaultViewController: GMSAutocompleteResultsViewControllerDelegate {

    // Handle the user's selection.
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {

        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        newDefaultPlace = place
        searchControllerOrigin.searchBar.text = place.name
        
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

