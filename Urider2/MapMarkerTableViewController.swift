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
        static var currentcity: City!
    }
    
    var searchBar: UISearchBar!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.placeholder = "search for rides"
        searchBar.delegate = self
        
        self.tableView.tableHeaderView = searchBar
        self.tableView.tableHeaderView?.isOpaque = true
        self.tableView.tableHeaderView?.backgroundColor = #colorLiteral(red: 0.3485831618, green: 0.614120543, blue: 1, alpha: 0.6)
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)

        
        cellList = markerCity.currentcity.rideList.filter({ (someRide) -> Bool in
            return true
        })
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    //MARK: fetch Marker's Rides
    
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "markerCell", for: indexPath) as! markerListTableViewCell
        
//        //set cell contents
//        var cellList: [Ride]!
//        
//        cellList = barButtonFilteredRides
//        
//        if (searchBar.text != "") {
//            cellList = searchFilteredRides
//        }
        
        cell.destinationLabel.text = cellList[indexPath.row].destination
        cell.startPointLabel.text = cellList[indexPath.row].origin
        cell.numberSeatsLabel.text = "\(cellList[indexPath.row].seats!)"
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
    
    
    //MARK: searchbar delegates
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchBar.text?.lowercased()
        print("filtering ride/request rides")
        var empty = false
        if (text == "") {
            empty = true
        }
        cellList = markerCity.currentcity.rideList.filter({ (someRide) -> Bool in
            var containsText = empty
            if (someRide.destination?.lowercased().contains(text!))! {
                containsText = true
            }
            if (someRide.origin?.lowercased().contains(text!))! {
                containsText = true
            }
            if (someRide.date?.lowercased().contains(text!))! {
                containsText = true
            }
            return containsText
        })
        tableView.reloadData()
        return
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("search button clicked")
        tapGestureDismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(dismissSearchKeyboard))
        self.view.addGestureRecognizer(tapGestureDismissKeyboard)
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search button clicked...")
        searchBar.resignFirstResponder()
        dismissSearchKeyboard()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        dismissSearchKeyboard()
    }
    
    func dismissSearchKeyboard() {
        print("resigning search-bar first responder status")
        searchBar.resignFirstResponder()
        self.view.removeGestureRecognizer(tapGestureDismissKeyboard)
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
