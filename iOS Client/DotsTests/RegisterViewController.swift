//
//  registerViewController.swift
//  Dots
//
//  Created by Bjarte Sjursen on 29.07.2016.
//  Copyright © 2016 Sjursen Software. All rights reserved.
//

import UIKit

class RegisterViewController: VirtualPropertyParentViewController, UITextFieldDelegate {
    
    @IBOutlet weak var createUserLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: RoundedButton!
    @IBOutlet weak var cancelButton: RoundedButton!
    var backGroundView : UIView!
    
    fileprivate var password : String? {
        get{
            return passwordTextField.text
        }
        set{
            passwordTextField.text = newValue
        }
    }
    
    fileprivate var username : String? {
        get{
            return usernameTextField.text
        }
        set{
            usernameTextField.text = newValue
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == usernameTextField {
            usernameTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            registerUser()
        }
        
        return true
        
    }
    
    override func viewDidLoad() {
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        
    }
    
    fileprivate func isValidCredentials() -> Bool {
        
        if password == nil || username == nil {
            return false
        }
        
        return !password!.isEmpty && !username!.isEmpty
        
    }
    
    func registerUser(){
        if Reachability.isConnectedToNetwork() {
            
            if isValidCredentials() {
                
                passwordTextField.resignFirstResponder()
                usernameTextField.resignFirstResponder()
                
                let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
                backGroundView = UIView(frame: view.frame)
                backGroundView.center = view.center
                backGroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
                activityIndicator.center = backGroundView.center
                backGroundView.addSubview(activityIndicator)
                backGroundView.bringSubview(toFront: activityIndicator)
                activityIndicator.startAnimating()
                
                view.addSubview(backGroundView)
                view.bringSubview(toFront: backGroundView)
                
                let queue = DispatchQueue(label: "My Queue", attributes: [])
                queue.async(execute: {
                
                    self.logoutUserHandler()
                    NetworkManager.registerUser(self.username!, password: self.password!, completionHandler: self.registrationHandler)
                    
                })
                
            }
            else {
                let alertController = UIAlertController(title: "Registration failed", message: "Enter valid credentials to register", preferredStyle: UIAlertControllerStyle.alert)
                let dismissView = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
                alertController.addAction(dismissView)
                self.present(alertController, animated: true, completion: nil)
            }
            
        }
        else {
            
            let alertController = UIAlertController(title: "Registration failed", message: "To perform this action you need an internet connection", preferredStyle: UIAlertControllerStyle.alert)
            let dismissView = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
            alertController.addAction(dismissView)
            self.present(alertController, animated: true, completion: nil)
            
        }

    }
    
    fileprivate func logoutUserHandler(){
        UserDefaults.standard.setValue("", forKey: usernameString)
        KeychainWrapper().mySetObject("", forKey:kSecValueData)
        KeychainWrapper().writeToKeychain()
        UserDefaults.standard.set(false, forKey: hasLoginKeyString)
        UserDefaults.standard.set(0, forKey: myScoreString)
        UserDefaults.standard.synchronize()
        token = ""
    }

    
    @IBAction func register(_ sender: AnyObject) {
        
        registerUser()
        
    }
    
    @IBAction func cancel(_ sender: AnyObject) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func viewGotTapped(_ sender: AnyObject) {
        
        resignFirstResponder()
        self.view.endEditing(true)
        
    }
    
    fileprivate func registrationHandler(_ data : Data?, response : URLResponse?, error : NSError?){
        if error == nil && data != nil {
            do {
                
                var json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
                
                print(json)
                
                if (json["token"] != nil) {
                    
                    token = json["token"] as! String
                    
                    UserDefaults.standard.setValue(self.username, forKey: usernameString)
                    KeychainWrapper().mySetObject(self.password, forKey:kSecValueData)
                    KeychainWrapper().writeToKeychain()
                    UserDefaults.standard.set(true, forKey: hasLoginKeyString)
                    UserDefaults.standard.set(true, forKey: firstScoreString)
                    UserDefaults.standard.synchronize()
                    
                    if(token != ""){
                        
                        DispatchQueue.main.async(execute: {
                            UIView.animate(withDuration: 1, animations: {
                                self.backGroundView.removeFromSuperview()
                                self.username = ""
                                self.password = ""
                                self.usernameTextField.text?.removeAll()
                                self.passwordTextField.text?.removeAll()
                                self.dismiss(animated: true, completion: nil)
                            })
                        })
                        
                    }
                    
                }
                else {
                    DispatchQueue.main.async(execute: {
                        UIView.animate(withDuration: 1, animations: {
                            self.backGroundView.removeFromSuperview()
                            let alertController = UIAlertController(title: "Registration failed", message: "Username already exists", preferredStyle: UIAlertControllerStyle.alert)
                            let dismissView = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                            alertController.addAction(dismissView)
                            self.present(alertController, animated: true, completion: nil)
                        })
                    })
                    
                }

                
            } catch {
                DispatchQueue.main.async(execute: {
                    UIView.animate(withDuration: 1, animations: {
                        self.backGroundView.removeFromSuperview()
                        let alertController = UIAlertController(title: "Registration failed", message: "Server error, please contact system administrator", preferredStyle: UIAlertControllerStyle.alert)
                        let dismissView = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                        alertController.addAction(dismissView)
                        self.present(alertController, animated: true, completion: nil)
                    })
                })

                print("Error while fetching data from mongo")
            }
        }
        
    }


}
