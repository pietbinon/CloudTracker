//
//  SignupViewController.swift
//  FoodTracker
//
//  Created by Pierre Binon on 2017-04-11.
//  Copyright © 2017 Pierre Binon. All rights reserved.
//

import UIKit


class SignupViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var incorrectInfoLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        incorrectInfoLabel.isHidden = true
    }
    
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
    //MARK: Actions
    @IBAction func saveButton(_ sender: Any) {
        
        guard (usernameTextField.text as String!) != nil else{
            
            self.incorrectInfoLabel.isHidden = false
            return
        }
        
        guard (passwordTextField.text as String!) != nil else{
            
            self.incorrectInfoLabel.isHidden = false
            return
        }
        
        guard ((passwordTextField.text!.characters.count) as Int) > 5 else {
            
            self.incorrectInfoLabel.isHidden = false
            return
        }
        
        
        let postData = [
            "username": usernameTextField.text ?? "",
            "password": passwordTextField.text ?? ""
        ]
        
        let defaults = UserDefaults.standard
        let cloudTracker = CloudTrackerAPI()
        
        cloudTracker.post(data: postData as [String : AnyObject], toEndpoint: "signup", completion: {
            
            (completion:(data: Data?, error: NSError?)) in
            guard let rawJSON = try? JSONSerialization.jsonObject(with: completion.data!, options: []) as! [String:[String:String]] else {
                
                print("data returned is not json, or not valid")
                return
            }
            
            defaults.set(rawJSON["user"], forKey: "user")
            self.dismiss(animated: true, completion: nil)
        })
    }
}
