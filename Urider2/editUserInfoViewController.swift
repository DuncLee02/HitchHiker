//
//  editUserInfoViewController.swift
//  Urider2
//
//  Created by Duncan Lee on 3/23/17.
//  Copyright © 2017 Duncan Lee. All rights reserved.
//

import UIKit


var selectionIndex = 0

class editUserInfoViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var profilePictureImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.clearsSelectionOnViewWillAppear = true
        
        profilePictureImage.layer.borderWidth = 1
        profilePictureImage.layer.masksToBounds = false
        profilePictureImage.layer.borderColor = UIColor.black.cgColor
        profilePictureImage.layer.cornerRadius = profilePictureImage.frame.height/2
        profilePictureImage.clipsToBounds = true
        profilePictureImage.image = #imageLiteral(resourceName: "profilePicture.png")
        profilePictureImage.image = #imageLiteral(resourceName: "profilePicture.png")
        
        nameLabel.text = LoginViewController.currentUser.name
        locationLabel.text = LoginViewController.currentUser.defaultName
        
        if (LoginViewController.currentUser.phoneNumber == "none") {
            numberLabel.text = "add a phone number"
        }
        else {
            numberLabel.text = PhoneNumberFormate(str: NSMutableString(string: LoginViewController.currentUser.phoneNumber))
        }

        
        
//        submitNameButton.backgroundColor = customGrey()
//        submitLocationButton.backgroundColor = customGrey()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        nameLabel.text = LoginViewController.currentUser.name
        locationLabel.text = LoginViewController.currentUser.defaultName
        
        if (LoginViewController.currentUser.phoneNumber == "none") {
            numberLabel.text = "add a phone number"
        }
        else {
            numberLabel.text = PhoneNumberFormate(str: NSMutableString(string: LoginViewController.currentUser.phoneNumber))
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 0) {
            let chosePicture = UIAlertController(title: "Profile Picture", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
            let fromLibrary = UIAlertAction(title: "chose Picture from library", style: .default , handler: { action in
                print("pulling up library")
                let imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self
                imagePickerController.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
                imagePickerController.allowsEditing = true
                self.present(imagePickerController, animated: true, completion: { imageP in
                    
                })
            })
            
//            let takePicture = UIAlertAction(title: "take picture", style: .default , handler: { action in
//                print("pulling up camera")
//                var imagePickerController = UIImagePickerController()
//                imagePickerController.delegate = self
//                imagePickerController.sourceType = UIImagePickerControllerSourceType.camera
//                imagePickerController.allowsEditing = true
//                self.present(imagePickerController, animated: true, completion: { imageP in
//                    LoginViewController.currentUser.photo = imageP
//                })
//            })

            
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { action in
                print("cancel")
                chosePicture.dismiss(animated: true, completion: nil)
            })
            
            chosePicture.addAction(fromLibrary)
            chosePicture.addAction(cancel)
            self.present(chosePicture, animated: true, completion: nil)
            return
        }
        
        selectionIndex = indexPath.row
        self.performSegue(withIdentifier: "segueToChangeDefault", sender: self)
    }
//    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        self.tableView.deselectRow(at: indexPath as IndexPath, animated: true)
//    }
//    
    

    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func PhoneNumberFormate( str : NSMutableString)->String{
        str.insert("(", at: 0)
        str.insert(") ", at: 4)
        str.insert("-", at: 9)
        return str as String
    }

    
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         let vc: ChangeDefaultViewController = segue.destination as! ChangeDefaultViewController
        vc.index = selectionIndex
    }
    
    @IBAction func unwindToUserInfo(segue: UIStoryboardSegue) {
    }

 

}


//extension editUserInfoViewController: GMSAutocompleteResultsViewControllerDelegate {
//    
//    // Handle the user's selection.
//    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
//        
//        print("Place name: \(place.name)")
//        print("Place address: \(place.formattedAddress)")
//        print("Place attributions: \(place.attributions)")
//        
//        defaultPlace = place
//        searchControllerOrigin.searchBar.text = place.formattedAddress
//        
//        dismiss(animated: true, completion: nil)
//    }
//    
//    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
//                           didFailAutocompleteWithError error: Error){
//        print("Error: ", error.localizedDescription)
//    }
//    
//    // Turn the network activity indicator on and off again.
//    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteResultsViewController) {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//    }
//    
//    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteResultsViewController) {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = false
//    }
//}
