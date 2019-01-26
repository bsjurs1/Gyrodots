//
//  LoginViewController.swift
//  Dots
//
//  Created by Bjarte Sjursen on 29.07.2016.
//  Copyright © 2016 Sjursen Software. All rights reserved.
//

import UIKit

class LoginViewController: VirtualPropertyParentViewController, UITextFieldDelegate {
    
    @IBOutlet weak var loginInfoLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: RoundedButton!
    @IBOutlet weak var registerButton: RoundedButton!
    @IBOutlet weak var containerView: UIView!
    var backGroundView : UIView!
    var scene : GameScene {
        get {
            return leaderBoardViewController.gameViewController.scene
        }
        set {
            leaderBoardViewController.gameViewController.scene = newValue
        }
    }
    
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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        containerView.backgroundColor = gameSceneBackgroundColor
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == usernameTextField {
            usernameTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            loginUser()
        }
        
        return true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if token != "" {
            view.removeFromSuperview()
            removeFromParentViewController()
        }
        
    }
    
    @IBAction func viewGotTapped(_ sender: AnyObject) {
        
        resignFirstResponder()
        self.view.endEditing(true)
        
    }
    
    fileprivate func isValidCredentials() -> Bool {
        
        if password == nil || username == nil {
            return false
        }
        
        return !password!.isEmpty && !username!.isEmpty
        
    }
    
    func loginUser(){
        
        if !scene.activeGame {
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
                        
                        NetworkManager.login(self.username!, password: self.password!, completionHandler: self.loginHandler)
                        NetworkManager.getScore(self.username!, token: token, completionHandler: self.getScoreHandler)
                        
                    })
                    
                }
                else {
                    let alertController = UIAlertController(title: "Login failed", message: "Enter valid credentials to sign in", preferredStyle: UIAlertControllerStyle.alert)
                    let dismissView = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
                    alertController.addAction(dismissView)
                    self.present(alertController, animated: true, completion: nil)
                }
                
            }
            else {
                
                let alertController = UIAlertController(title: "Login failed", message: "To perform this action you need an internet connection", preferredStyle: UIAlertControllerStyle.alert)
                let dismissView = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
                alertController.addAction(dismissView)
                self.present(alertController, animated: true, completion: nil)
                
            }

        } else if scene.activeGame {
            
            let alertController = UIAlertController(title: "Login failed", message: "To log in you need to end the active game", preferredStyle: UIAlertControllerStyle.alert)
            let dismissView = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
            alertController.addAction(dismissView)
            self.present(alertController, animated: true, completion: nil)

        }
        
    }
    
    @IBAction func login(_ sender: AnyObject) {
        
        loginUser()
        
    }
    
    fileprivate func loginHandler(_ data : Data?, response : URLResponse?, error : NSError?){
        if error == nil && data != nil {
            do {
                var json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
                
                if (json["token"] != nil) {
                    token = json["token"] as! String
                
                    UserDefaults.standard.setValue(self.username, forKey: usernameString)
                    KeychainWrapper().mySetObject(self.password, forKey:kSecValueData)
                    KeychainWrapper().writeToKeychain()
                    UserDefaults.standard.set(true, forKey: hasLoginKeyString)
                    UserDefaults.standard.synchronize()
                    
                    if(token != ""){
                        DispatchQueue.main.async(execute: {
                            UIView.animate(withDuration: 1, animations: {
                                self.username = ""
                                self.password = ""
                                self.usernameTextField.text?.removeAll()
                                self.passwordTextField.text?.removeAll()
                                self.leaderBoardViewController.viewDidAppear(true)
                                self.view.removeFromSuperview()
                                self.removeFromParentViewController()
                            })
                        })
                    }

                }
                else {
                    DispatchQueue.main.async(execute: {
                        UIView.animate(withDuration: 1, animations: {
                            let alertController = UIAlertController(title: "Login failed", message: "Enter correct username and password", preferredStyle: UIAlertControllerStyle.alert)
                            let dismissView = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                            alertController.addAction(dismissView)
                            self.present(alertController, animated: true, completion: nil)
                        })
                    })
                    
                }

                                
            } catch {
                print(error)
                print("Error in loginHandler")
            }
        }
    }
    
    fileprivate func getScoreHandler(_ data : Data?, response : URLResponse?, error : NSError?){
        
        if error == nil && data != nil {
            do {
                print(data)
                if let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? Array<Dictionary<String, AnyObject>> {
                    UserDefaults.standard.set(json[0]["score"] as! Int, forKey: myScoreString)
                    UserDefaults.standard.set(false, forKey: firstScoreString)
                    UserDefaults.standard.synchronize()
                    
                }
                else if let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? Dictionary<String, AnyObject> {
                    
                    if let score = json["score"] as? Int {
                        UserDefaults.standard.set(score, forKey: myScoreString)
                        UserDefaults.standard.set(false, forKey: firstScoreString)
                        
                    } else {
                        UserDefaults.standard.set(true, forKey: firstScoreString)
                    }
                    UserDefaults.standard.synchronize()
                }
                
                if(token != ""){
                    DispatchQueue.main.async(execute: {
                        UIView.animate(withDuration: 1, animations: {
                            self.leaderBoardViewController.displayScore()
                        })
                    })
                }
                
                DispatchQueue.main.async(execute: {
                    UIView.animate(withDuration: 1, animations: {
                        self.backGroundView.removeFromSuperview()
                    })
                })

                
            } catch {
                print(error)
                print("Error in getScoreHandler")
            }
        }
        else {
            print(error)
            print("Error in getScoreHandler")
        }
        
        
        
    }
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        
        if identifier == "register" {
            
            let registerViewControllerToPresent = (sender as AnyObject).destination as! RegisterViewController
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
            let beView = UIVisualEffectView(effect: blurEffect)
            beView.frame = UIScreen.main.bounds
            
            registerViewControllerToPresent.view.frame = UIScreen.main.bounds
            registerViewControllerToPresent.view.backgroundColor = UIColor.clear
            registerViewControllerToPresent.view.insertSubview(beView, at: 0)
            
            registerViewControllerToPresent.loginViewController = self
            
        }
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "register" && !scene.activeGame{
            
            return true
            
        } else if identifier == "register" && scene.activeGame {
            
            let alertController = UIAlertController(title: "User creation failed", message: "To create a new user you need to end the active game", preferredStyle: UIAlertControllerStyle.alert)
            let dismissView = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
            alertController.addAction(dismissView)
            self.present(alertController, animated: true, completion: nil)
            
            return false
            
        }
        return false
    }
    


    
    
}
