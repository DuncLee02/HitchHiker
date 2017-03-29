//
//  riderInfoViewController.swift
//  Urider2
//
//  Created by Duncan Lee on 2/7/17.
//  Copyright © 2017 Duncan Lee. All rights reserved.
//

import UIKit
import FirebaseDatabase

class riderInfoViewController: UITableViewController {

    
    var ref: FIRDatabaseReference!
    var ride: Ride!
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        
    
//        ref.child("ridesDuncan").child(ride.destination!).child(ride.key!).child("riders").observe(.childAdded, with: { (snapshot) in
//            
//            if let aRider = snapshot.value as? String {
//                var newRider = Rider()
//                newRider.email = aRider
//                newRider.uid = snapshot.key
//                self.riderInfo.append(newRider)
//                // Double-check that the correct data is being pulled by printing to the console.
//                
//                // async download so need to reload the table that this data feeds into.
//                self.tableView.reloadData()
//            }
//            
//        })
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: TableViewController Delegates
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ride.riders!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "riderInfoTableCell", for: indexPath) as! riderInfoTableViewCell
        
        cell.emailLabel.text = ride.riders![indexPath.row].email
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        print("editing")
        if editingStyle == UITableViewCellEditingStyle.delete {
            ref.child("userRides").child(LoginViewController.currentUser.uid).child("posted").child(ride.key!).child("riders").child(ride.riders![indexPath.row].uid).removeValue()
            ref.child("userRides").child(ride.riders![indexPath.row].uid).child("accepted").child(ride.key!).removeValue()
            
            DispatchQueue.main.async {
                self.ride.riders!.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .left)
            }
        }

    }
    
    
   
    
    
    //MARK: –Button Delegates
    
    @IBAction func editButtonPressed(_ sender: Any) {
        if(self.tableView.isEditing == false)
        {
            self.tableView.setEditing(true, animated: true)
            self.editButton.title = "Done"
            
        }
        else
        {
            self.tableView.setEditing(false, animated: true)
            self.editButton.title = "Edit"
            
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
