//
//  NewRideViewController.swift
//  Urider2
//
//  Created by Duncan Lee on 1/6/17.
//  Copyright © 2017 Duncan Lee. All rights reserved.
//

import UIKit
import Foundation
//import Firebase
//import FirebaseDatabase
import GooglePlaces


class NewRideViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UISearchDisplayDelegate{
    
//    var ref: FIRDatabaseReference!
    
    var datePicker: UIDatePicker!
    var passengerPicker: UIPickerView!
    var alert: UIAlertController!
    var passengerPickerDataSource: [String]!
    
    var newRideIsRequest: Bool!
    var rideTypeWasSet: Bool = false
    var nonSmoking: Bool = true
    var petsProhibited: Bool = true
    var oneWayTrip: Bool = true
    
    var newRide: Ride!
    
//    //GMS Page Variables
//    var GMSResultsViewController: GMSAutocompleteViewController?
//    var resultView: UITextView?
    var GMSWhichFieldTag: String! //to tag which textfield is being edited
//    var destinationSearchController: UISearchController!
//    var originSearchController: UISearchController?
//    
    
   //GMS SearchBar
    var resultsViewControllerOrigin: GMSAutocompleteResultsViewController!
    var searchControllerOrigin: UISearchController!
    
    var resultsViewControllerDestination: GMSAutocompleteResultsViewController!
    var searchControllerDestination: UISearchController!

    
    
    
    //labels
    @IBOutlet weak var DestinationLabel: UITextField!
    @IBOutlet weak var OriginLabel: UITextField!
    @IBOutlet weak var PassengersLabel: UITextField!
    @IBOutlet weak var TimeLabel: UITextField!
    @IBOutlet weak var DateLabel: UITextField!
    @IBOutlet weak var AddRideButton: UIButton!
    @IBOutlet weak var backgroundOptionsLabel: UILabel!
    
    //switches and buttons
    @IBOutlet weak var rideBooleanButton: UIButton!
    @IBOutlet weak var requestBooleanButton: UIButton!
    @IBOutlet weak var nonSmokingSwitch: UISwitch!
    @IBOutlet weak var petsProhibitedSwitch: UISwitch!
    @IBOutlet weak var oneWaySwitch: UISwitch!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set delegates
        
        
        newRide = Ride()
        DateLabel.delegate = self
        TimeLabel.delegate = self
        PassengersLabel.delegate = self
        OriginLabel.delegate = self
        DestinationLabel.delegate = self
        PassengersLabel.text = "0"
        
        //initialize textfield values
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        DateLabel.text = dateFormatter.string(from: date as Date)
        TimeLabel.text = "12:00 PM"
        
        //other
        backgroundOptionsLabel.layer.masksToBounds = true
        backgroundOptionsLabel.layer.cornerRadius = 8
        rideBooleanButton.layer.cornerRadius = 5
        rideBooleanButton.layer.borderWidth = 1
        rideBooleanButton.layer.borderColor = UIColor.blue.cgColor
        requestBooleanButton.layer.cornerRadius = 5
        requestBooleanButton.layer.borderWidth = 1
        requestBooleanButton.layer.borderColor = UIColor.blue.cgColor
        
        
        
//        //initialize GMSAutocompleteObject
//        GMSResultsViewController = GMSAutocompleteViewController()
//        GMSResultsViewController?.delegate = self
//        
        
        
        //initialize GMSSearchBar
        resultsViewControllerOrigin = GMSAutocompleteResultsViewController()
        resultsViewControllerOrigin.delegate = self
        searchControllerOrigin = UISearchController(searchResultsController: resultsViewControllerOrigin)
        searchControllerOrigin.searchBar.placeholder = "enter origin"
        //searchControllerOrigin.searchBar.prompt = "Origin"
        searchControllerOrigin.searchResultsUpdater = resultsViewControllerOrigin
        
        let subView = UIView(frame: CGRect(x: 0, y: 63.0, width: view.frame.width, height: 45.0))
        subView.addSubview((searchControllerOrigin.searchBar))
        view.addSubview(subView)
        searchControllerOrigin.searchBar.sizeToFit()
        searchControllerOrigin.hidesNavigationBarDuringPresentation = false
        
        resultsViewControllerDestination = GMSAutocompleteResultsViewController()
        resultsViewControllerDestination.delegate = self
        searchControllerDestination = UISearchController(searchResultsController: resultsViewControllerDestination)
        searchControllerDestination.searchBar.placeholder = "enter destination"
        //searchControllerDestination.searchBar.prompt = "Destination"
        searchControllerDestination.searchResultsUpdater = resultsViewControllerDestination
        
        let subView2 = UIView(frame: CGRect(x: 0, y: 105, width: view.frame.width, height: 45.0))
        subView2.addSubview((searchControllerDestination.searchBar))
        view.addSubview(subView2)
        searchControllerDestination.searchBar.sizeToFit()
        searchControllerDestination.hidesNavigationBarDuringPresentation = false
        
        definesPresentationContext = true
        
        
        passengerPickerDataSource = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"]
        
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector(("dismissDateFieldPicker")))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    //MARK sending to server
    
    @IBAction func addRidePressed(_ sender: Any) {
        print("Action Recieved")
            //sends alert if no destination entered
        
        if (rideTypeWasSet == false) {
            print("ride type was not set")
            let alertController = UIAlertController(title: "Can't submit", message:
                "No ride-type checked", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        if searchControllerDestination.searchBar.text == "" {
            print("no destination entered")
            let alertController = UIAlertController(title: "Can't submit", message:
                "No destination entered", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
            //sends alert if no origin entered
        if searchControllerOrigin.searchBar.text == "" {
            print("no origin entered")
            let alertController = UIAlertController(title: "Can't submit", message:
                "No origin entered", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            //self.presentViewController(alertController, animated: true, completion: nil)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        print("loading data...")
        
        newRide.date = DateLabel.text
        newRide.seats = Int(PassengersLabel.text!)
        newRide.destination = searchControllerDestination.searchBar.text
        newRide.origin = searchControllerOrigin.searchBar.text
        newRide.isPassenger = newRideIsRequest
        newRide.time = TimeLabel.text
        newRide.oneWay = oneWayTrip
        newRide.petsProhibited = petsProhibited
        newRide.nonSmoking = nonSmoking
        
        let aRideDict = [ "date": newRide.date!, "destination": newRide.destination!, "isPassenger": newRide.isPassenger!, "seats": newRide.seats!, "origin": newRide.origin!, "time": newRide.time!, "oneWay": oneWayTrip, "petsProhibited" : petsProhibited, "nonSmoking": nonSmoking] as [String : Any]
        print(aRideDict)
        
        self.performSegue(withIdentifier: "lastViewToAddRide", sender: self)
    }
    

        // Do any additional setup after loading the view.

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Button Delegates
    
    @IBAction func rideBooleanButtonPressed(_ sender: Any) {
        booleanButtonsPressed(isRide: true)
    }
    
    @IBAction func requestBooleanButtonPressed(_ sender: Any) {
        booleanButtonsPressed(isRide: false)
    }
    
    func booleanButtonsPressed(isRide: Bool) {
        rideTypeWasSet = true
        if (isRide == true) {
            newRideIsRequest = false
            rideBooleanButton.setImage(#imageLiteral(resourceName: "checked.png"), for: .normal)
            requestBooleanButton.setImage(nil, for: .normal)
            
        }
        if (isRide == false) {
            newRideIsRequest = true
            rideBooleanButton.setImage(nil, for: .normal)
            requestBooleanButton.setImage(#imageLiteral(resourceName: "checked.png"), for: .normal)
            
        }
    }
    
    @IBAction func nonsmokingSwitchValueChanged(_ sender: Any) {
        if (nonSmokingSwitch.isOn) {
            nonSmoking = true
        }
        else {
            nonSmoking = false
        }
    }
    
    @IBAction func petsProhibitedSwitchValueChanged(_ sender: Any) {
        if (petsProhibitedSwitch.isOn) {
            petsProhibited = true
        }
        else {
            petsProhibited = false
        }
        
    }
    
    @IBAction func oneWaySwitchValueChanged(_ sender: Any) {
        if (oneWaySwitch.isOn) {
            oneWayTrip = true
        }
        else {
            oneWayTrip = false
        }
    }
    
    // MARK: DatePicker Delegates
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == DateLabel {
            let aDatePicker = UIDatePicker()
            datePicker = aDatePicker
            datePicker.minimumDate = datePicker.date
            datePicker.datePickerMode = UIDatePickerMode.date
            textField.inputView = datePicker
            datePicker.addTarget(self, action: #selector(datePickerChanged), for: UIControlEvents.valueChanged)
            datePickerChanged()
            NSLog("dateFieldDidBeginEditing: The day is %", self.datePicker)
        }
        if textField == TimeLabel {
            let aDatePicker = UIDatePicker()
            datePicker = aDatePicker
            datePicker.datePickerMode = UIDatePickerMode.time
            let todaysDate = NSDate()
            datePicker.minimumDate = todaysDate as Date
            datePicker.minuteInterval = 15
            textField.inputView = datePicker
            //set initial value
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm a"
            datePicker.date = formatter.date(from: "12:00 pm")!
            
            datePicker.addTarget(self, action: #selector(timePickerChanged), for: UIControlEvents.valueChanged)
            timePickerChanged()
            NSLog("timeFieldDidBeginEditing: The time is %", self.datePicker)
        }
        if textField == PassengersLabel {
            let anIntPicker = UIPickerView()
            passengerPicker = anIntPicker
            passengerPicker.delegate = self
            passengerPicker.dataSource = self
            textField.inputView = passengerPicker
        }
    }
    
    func datePickerChanged() {
        NSLog("datePickerChanged: The day is %", self.datePicker)
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        DateLabel.text = formatter.string(from: datePicker.date)
    }
    
    func timePickerChanged() {
        NSLog("timePickerChanged: The time is %", self.datePicker)
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        TimeLabel.text = formatter.string(from: datePicker.date)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func dismissDateFieldPicker() {
        print("resigning first responder")
        self.view.endEditing(true)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "lastViewToAddRide") {
            let messageForRideVC: newRideMessageViewController = segue.destination as! newRideMessageViewController
            
            messageForRideVC.rideToBeAdded = newRide
        }
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

extension NewRideViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return passengerPickerDataSource[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return passengerPickerDataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //pickerView.selectRow(row, inComponent: component , animated: true)
        PassengersLabel.text = String(row)
        print(row)
    }
    
}



extension NewRideViewController: GMSAutocompleteResultsViewControllerDelegate {
    
    // Handle the user's selection.
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        if (resultsController == resultsViewControllerOrigin) {
            searchControllerOrigin.searchBar.text = place.formattedAddress!
            print("Origin is " + place.formattedAddress!)
        }
        if (resultsController == resultsViewControllerDestination) {
            searchControllerDestination.searchBar.text = place.formattedAddress!
            print("Destination is " + place.formattedAddress!)
        }
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


