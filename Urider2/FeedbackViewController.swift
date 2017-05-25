//
//  FeedbackViewController.swift
//  Urider2
//
//  Created by Duncan Lee on 4/9/17.
//  Copyright © 2017 Duncan Lee. All rights reserved.
//

import UIKit
import FirebaseDatabase

class FeedbackViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var feedbackTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    var touchRecognizer = UITapGestureRecognizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        feedbackTextView.layer.borderColor = UIColor.lightGray.cgColor
        feedbackTextView.layer.borderWidth = 3
        feedbackTextView.delegate = self
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    @IBAction func sendFeedbackButtonPressed(_ sender: Any) {
        if (feedbackTextView.text != "") {
            let ref = FIRDatabase.database().reference()
            ref.child("feedback").childByAutoId().setValue(feedbackTextView.text)
            feedbackTextView.text = ""
            let alert = UIAlertController(title: "feedback submitted!", message: "Thank you for feedback!", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                (_)in
                print("performing segue")
                self.performSegue(withIdentifier: "unwindSegue", sender: self)
            })
            print("data sent")
            alert.addAction(OKAction)
            self.present(alert, animated: true, completion: nil)

        }
        else{
            let alert = UIAlertController(title: "can't submit", message: "nothing entered", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //TextViewDelegate
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        print("adding tapGest")
        self.view.addGestureRecognizer(touchRecognizer)
        touchRecognizer.addTarget(self, action: #selector(dismissTextView))
        return true
    }
    
    func dismissTextView() {
        print("resigning")
        self.feedbackTextView.resignFirstResponder()
        self.view.removeGestureRecognizer(touchRecognizer)
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
