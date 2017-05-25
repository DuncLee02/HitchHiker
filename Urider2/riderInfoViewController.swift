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
    var selectedRowIndex = -1
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: TableViewController Delegates
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print("changing height")
        if indexPath.row == selectedRowIndex {
            print("expanded")
            return 90 //Expanded
        }
        return 40 //Not expanded
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedRowIndex == indexPath.row {
            selectedRowIndex = -1
            tableView.reloadRows(at: [indexPath], with: .automatic)
            return
        }
        
        selectedRowIndex = indexPath.row
        ref = FIRDatabase.database().reference()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ride.riders!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "riderInfoTableCell", for: indexPath) as! riderInfoTableViewCell
        
        cell.nameLabel.text = ride.riders![indexPath.row].name
        cell.passenger = ride.riders![indexPath.row]
        cell.numberLabel.text = PhoneNumberFormate( str : NSMutableString(string: ride.riders![indexPath.row].number))
        cell.emailLabel.text = ride.riders![indexPath.row].email
        return cell
    }
    
    func PhoneNumberFormate( str : NSMutableString)->String{
        str.insert("(", at: 0)
        str.insert(") ", at: 4)
        str.insert("-", at: 9)
        return str as String
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    //MARK: -TableViewEditting Delegates
    
    
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
            ref.child("userRides").child(LoginViewController.currentUser.uid).child("posted").child(ride.key!).child("riders").child((ride.riders?[indexPath.row].uid)!).removeValue()
            ref.child("userRides").child((ride.riders?[indexPath.row].uid)!).child("accepted").child(ride.key!).removeValue()
            
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
