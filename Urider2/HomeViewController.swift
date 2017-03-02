//
//  HomeViewController.swift
//  Urider2
//
//  Created by Duncan Lee on 2/28/17.
//  Copyright © 2017 Duncan Lee. All rights reserved.
//

import UIKit
import GooglePlacePicker
import FirebaseAuth
import FirebaseDatabase
import GoogleMaps
import GooglePlaces

var mapView: GMSMapView!

class HomeViewController: UIViewController{
    
    
    //GMS SearchBar
    var resultsViewControllerOrigin: GMSAutocompleteResultsViewController!
    var searchControllerOrigin: UISearchController!
    
    var resultsViewControllerDestination: GMSAutocompleteResultsViewController!
    var searchControllerDestination: UISearchController!

    
    //SWReveal Button
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initialize autocomplete filter:
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        
        //initialize mapview
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        mapView = GMSMapView.map(withFrame: self.view.bounds, camera: camera)
        self.view.insertSubview(mapView, at: 0)

        
        //initialize GMSSearchBars
        resultsViewControllerOrigin = GMSAutocompleteResultsViewController()
        resultsViewControllerOrigin.delegate = self
        resultsViewControllerOrigin.autocompleteFilter = filter    //remove this to allow specific address
        searchControllerOrigin = UISearchController(searchResultsController: resultsViewControllerOrigin)
//        searchControllerOrigin.searchBar.alpha = 0.9
        searchControllerOrigin.searchBar.placeholder = "from"
        searchControllerOrigin.searchResultsUpdater = resultsViewControllerOrigin
        
        let subView = UIView(frame: CGRect(x: 0, y: 63.0, width: view.frame.width, height: 45.0))
        subView.addSubview((searchControllerOrigin.searchBar))
        
        self.view.addSubview(subView)
        searchControllerOrigin.searchBar.sizeToFit()
        searchControllerOrigin.hidesNavigationBarDuringPresentation = false
        
        resultsViewControllerDestination = GMSAutocompleteResultsViewController()
        resultsViewControllerDestination.delegate = self
        resultsViewControllerDestination.autocompleteFilter = filter //remove this to allow specific address
        searchControllerDestination = UISearchController(searchResultsController: resultsViewControllerDestination)
        searchControllerDestination.searchBar.placeholder = "to"
//        searchControllerDestination.searchBar.alpha = 0.9
        //searchControllerDestination.searchBar.prompt = "Destination"
        searchControllerDestination.searchResultsUpdater = resultsViewControllerDestination
        
        let subView2 = UIView(frame: CGRect(x: 0, y: 105, width: view.frame.width, height: 45.0))
        subView2.addSubview((searchControllerDestination.searchBar))
        view.addSubview(subView2)
        searchControllerDestination.searchBar.sizeToFit()
        searchControllerDestination.hidesNavigationBarDuringPresentation = false
        
        definesPresentationContext = true

        
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    //MARK: Searchbar Delegates
   
    
    

}

extension HomeViewController: GMSAutocompleteResultsViewControllerDelegate {
    
    // Handle the user's selection.
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        if (resultsController == resultsViewControllerOrigin) {
            print("Origin is " + place.formattedAddress!)
        }
        if (resultsController == resultsViewControllerDestination) {
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



