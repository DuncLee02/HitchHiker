//
//  MapMarkerTableViewController.swift
//  Urider2
//
//  Created by Duncan Lee on 2/22/17.
//  Copyright © 2017 Duncan Lee. All rights reserved.
//

import UIKit
import FirebaseDatabase

class MapMarkerTableViewController: UITableViewController, UISearchBarDelegate {
    
    var ref: FIRDatabaseReference!
    var refHandle: UInt!
    var cellList = [Ride]()
    var searchFilteredRides = [Ride]()
    var barButtonFilteredRides = [Ride]()
    var tapGestureDismissKeyboard: UITapGestureRecognizer!
    
    
    struct markerCity {
        static var currentCity: City!
        static var subset: String!
        static var Outgoing: Bool!
    }
    
    var noRidesLabel = UILabel()
    var directionFlipped = false
    var viewAll = false
    var searchBar: UISearchBar!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        searchBar = UISearchBar()
//        searchBar.sizeToFit()
//        searchBar.placeholder = "search for rides"
//        searchBar.delegate = self
        
        
        
//        if (markerCity.currentCity.rideList.count == 0) {
//            self.navigationItem.title = "No Rides Found"
//        }
        
        if (markerCity.subset == "View All") {
            markerCity.subset = "?"
            viewAll = true
        }
        
        let nameArray1 = markerCity.currentCity.cityInfo.name.components(separatedBy: ",")
        let nameArray2 = markerCity.subset.components(separatedBy: ",")
        
        self.navigationItem.title = nameArray1[0] + " -> " + nameArray2[0]
//        self.tableView.tableHeaderView = flipButton
//        flipButton.sizeToFit()
        self.tableView.tableHeaderView?.isOpaque = true
        self.tableView.tableHeaderView?.tintColor = #colorLiteral(red: 0.3485831618, green: 0.614120543, blue: 1, alpha: 0.6)
        
        noRidesLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        self.view.addSubview(noRidesLabel)
        noRidesLabel.contentMode = .center
        noRidesLabel.layer.position = CGPoint(x: self.view.frame.midX, y: self.view.frame.midY)
        
        if (markerCity.Outgoing == false) {
            filterIngoingRides()
            return
        }
        
        filterRides()
    }
    
    
    
    //MARK: fetch Marker's Rides
    
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    // MARK: - Table view data source
    
    
    func filterRides() {
        
        let nameArray1 = markerCity.currentCity.cityInfo.name.components(separatedBy: ",")
        let nameArray2 = markerCity.subset.components(separatedBy: ",")
        
        if (viewAll == false) {
            if (directionFlipped == false) {
                self.navigationItem.title = nameArray1[0] + " -> " + nameArray2[0]
                cellList = markerCity.currentCity.rideList.filter({ (someRide) -> Bool in
                    if (someRide.destination == markerCity.subset) {
                        return true
                    }
                    return false
                })
                
                if (cellList.count == 0) {
                    noRidesLabel.text = "No Rides Found"
                }
                else {
                    noRidesLabel.text = ""
                }
                
                self.tableView.reloadData()
            }
            
            if (directionFlipped == true) {
                self.navigationItem.title = nameArray2[0] + " -> " + nameArray1[0]
                cellList = markerCity.currentCity.rideList.filter({ (someRide) -> Bool in
                    if (someRide.origin == markerCity.subset) {
                        return true
                    }
                    return false
                })
                
                if (cellList.count == 0) {
                    noRidesLabel.text = "No Rides Found"
                }
                else {
                    noRidesLabel.text = ""
                }
                
                self.tableView.reloadData()
            }
        }
        
        else {
            if (directionFlipped == false) {
                self.navigationItem.title = nameArray1[0] + " -> " + nameArray2[0]
                cellList = markerCity.currentCity.rideList.filter({ (someRide) -> Bool in
                    if (someRide.origin == markerCity.currentCity.cityInfo.name) {
                        return true
                    }
                    return false
                })
                
                if (cellList.count == 0) {
                    noRidesLabel.text = "No Rides Found"
                }
                else {
                    noRidesLabel.text = ""
                }
                
                self.tableView.reloadData()
            }
            
            if (directionFlipped == true) {
                self.navigationItem.title = nameArray2[0] + " -> " + nameArray1[0]
                cellList = markerCity.currentCity.rideList.filter({ (someRide) -> Bool in
                    if (someRide.destination == markerCity.currentCity.cityInfo.name) {
                        return true
                    }
                    return false
                })
                
                if (cellList.count == 0) {
                    noRidesLabel.text = "No Rides Found"
                }
                else {
                    noRidesLabel.text = ""
                }
                
                self.tableView.reloadData()
            }
        }
        
    }
    
    
    
    func filterIngoingRides() {
        
        let nameArray1 = markerCity.currentCity.cityInfo.name.components(separatedBy: ",")
        let nameArray2 = markerCity.subset.components(separatedBy: ",")
        
        if (viewAll == false) {
            if (directionFlipped == false) {
                self.navigationItem.title = nameArray2[0] + " -> " + nameArray1[0]
                cellList = markerCity.currentCity.rideList.filter({ (someRide) -> Bool in
                    if (someRide.origin == markerCity.subset) {
                        return true
                    }
                    return false
                })
                
                if (cellList.count == 0) {
                    noRidesLabel.text = "No Rides Found"
                }
                else {
                    noRidesLabel.text = ""
                }
                
                self.tableView.reloadData()
            }
            
            if (directionFlipped == true) {
                self.navigationItem.title = nameArray1[0] + " -> " + nameArray2[0]
                cellList = markerCity.currentCity.rideList.filter({ (someRide) -> Bool in
                    if (someRide.destination == markerCity.subset) {
                        return true
                    }
                    return false
                })
                
                if (cellList.count == 0) {
                    noRidesLabel.text = "No Rides Found"
                }
                else {
                    noRidesLabel.text = ""
                }
                
                self.tableView.reloadData()
            }
        }
            
        else {
            if (directionFlipped == false) {
                self.navigationItem.title = nameArray2[0] + " -> " + nameArray1[0]
                cellList = markerCity.currentCity.rideList.filter({ (someRide) -> Bool in
                    if (someRide.destination == markerCity.currentCity.cityInfo.name) {
                        return true
                    }
                    return false
                })
                
                if (cellList.count == 0) {
                    noRidesLabel.text = "No Rides Found"
                }
                else {
                    noRidesLabel.text = ""
                }
                
                self.tableView.reloadData()
            }
            
            if (directionFlipped == true) {
                self.navigationItem.title = nameArray1[0] + " -> " + nameArray2[0]
                cellList = markerCity.currentCity.rideList.filter({ (someRide) -> Bool in
                    if (someRide.origin == markerCity.currentCity.cityInfo.name) {
                        return true
                    }
                    return false
                })
                
                if (cellList.count == 0) {
                    noRidesLabel.text = "No Rides Found"
                }
                else {
                    noRidesLabel.text = ""
                }
                
                self.tableView.reloadData()
            }
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellList.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "markerCell", for: indexPath) as! markerListTableViewCell
        
        cell.destinationLabel.text = cellList[indexPath.row].destination
        cell.startPointLabel.text = cellList[indexPath.row].origin
        cell.numberSeatsLabel.text = "\(cellList[indexPath.row].seats! - (cellList[indexPath.row].riders?.count)!)"
        cell.dateLabel.text = cellList[indexPath.row].date
        cell.timeLabel.text = cellList[indexPath.row].time
        
        cell.viewButton.layer.cornerRadius = 5
        cell.viewButton.layer.borderWidth = 1
        cell.viewButton.layer.borderColor = UIColor.blue.cgColor
        cell.backgroundColor = UIColor.white
        
        
        if (cellList[indexPath.row].isPassenger == true) {
            cell.rideOrRequestIcon.image = #imageLiteral(resourceName: "PassengerIcon.png")
            //print("inserting icon...")
        }
        else {
            cell.rideOrRequestIcon.image = #imageLiteral(resourceName: "steeringWheelIcon.jpeg")
        }
        if (cellList[indexPath.row].oneWay == false) {
            cell.roundTripIcon.image = #imageLiteral(resourceName: "roundTrip.png")
            //print("inserting icon...")
        }
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("clicked cell, pulling up ride")
        self.performSegue(withIdentifier: "segueToViewRide", sender: self)
    }
    
    //MARK: flipButton Delegates
    
    @IBAction func switchDirection(_ sender: Any) {
        directionFlipped = !directionFlipped
        if markerCity.Outgoing == true {
            filterRides()
            return
        }
        filterIngoingRides()
                
    }
    
    
//    //MARK: searchbar delegates
//    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        let text = searchBar.text?.lowercased()
//        print("filtering ride/request rides")
//        var empty = false
//        if (text == "") {
//            empty = true
//        }
//        cellList = markerCity.currentCity.rideList.filter({ (someRide) -> Bool in
//            var containsText = empty
//            if (someRide.destination?.lowercased().contains(text!))! {
//                containsText = true
//            }
//            if (someRide.origin?.lowercased().contains(text!))! {
//                containsText = true
//            }
//            if (someRide.date?.lowercased().contains(text!))! {
//                containsText = true
//            }
//            return containsText
//        })
//        tableView.reloadData()
//        return
//    }
//    
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        print("search button clicked")
//        tapGestureDismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(dismissSearchKeyboard))
//        self.view.addGestureRecognizer(tapGestureDismissKeyboard)
//    }
//    
//    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        print("search button clicked...")
//        searchBar.resignFirstResponder()
//        dismissSearchKeyboard()
//    }
//    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.text = ""
//        dismissSearchKeyboard()
//    }
//    
//    func dismissSearchKeyboard() {
//        print("resigning search-bar first responder status")
//        searchBar.resignFirstResponder()
//        self.view.removeGestureRecognizer(tapGestureDismissKeyboard)
//    }

    
    
    // MARK: - Navigation

    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueToViewRide") {
            let indexPath = self.tableView.indexPathForSelectedRow?.row
            let viewRideVC: viewRideFromTableViewController = segue.destination as! viewRideFromTableViewController
            
            viewRideVC.rideBeingViewed = cellList[indexPath!]
            viewRideVC.cityInTable = markerCity.currentCity
        }
    }
 
    

}
