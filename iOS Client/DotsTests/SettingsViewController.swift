//
//  SettingsViewController.swift
//  Dots
//
//  Created by Bjarte Sjursen on 29.07.2016.
//  Copyright © 2016 Sjursen Software. All rights reserved.
//

import UIKit

class SettingsViewController: VirtualPropertyParentViewController {
    
    @IBOutlet weak var backButton: RoundedButton!
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var musicButton: RoundedButton!
    @IBOutlet weak var logOutButton: RoundedButton!
    @IBOutlet weak var deleteButton: RoundedButton!
    var username = String()
    var backGroundView : UIView!
    var scene : GameScene {
        get{
            return gameViewController.scene
        }
        set {
            gameViewController.scene = newValue
        }

    }
    
    @IBAction func returnToMainMenu(_ sender: AnyObject) {
        
        mainMenuViewController.returnToMainMenu()
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let isMusicOn = UserDefaults.standard.bool(forKey: isMusicOnString)
        if isMusicOn {
            musicButton.setTitle("Turn music off", for: UIControlState())
        }
        else {
            musicButton.setTitle("Turn music on", for: UIControlState())
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if token == "" && Reachability.isConnectedToNetwork() {
            
            let hasLoginKey = UserDefaults.standard.bool(forKey: hasLoginKeyString)
            if hasLoginKey == true {
                let username = UserDefaults.standard.string(forKey: usernameString)!
                let password = KeychainWrapper().myObject(forKey: "v_Data") as! String
                NetworkManager.login(username, password: password, completionHandler: loginHandler)
            }

            
        }
        
    }

    @IBAction func changeMusicState(_ sender: AnyObject) {
        
        let isMusicOn = UserDefaults.standard.bool(forKey: isMusicOnString)
        
        if isMusicOn {
            musicButton.setTitle("Turn music on", for: UIControlState())
            UserDefaults.standard.set(false, forKey: isMusicOnString)
        } else {
            musicButton.setTitle("Turn music off", for: UIControlState())
            UserDefaults.standard.set(true, forKey: isMusicOnString)
        }
        
        UserDefaults.standard.synchronize()
        
    }
    
    @IBAction func logout(_ sender: AnyObject) {
        
        if !scene.activeGame {
            if token != "" {
                
                let alertController = UIAlertController(title: "Are you sure you want to log out?", message: "Logging out will disable the leader board", preferredStyle: UIAlertControllerStyle.alert)
                let dismissView = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
                let logoutOK = UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: {
                    alertAction in
                    self.logoutUserHandler()
                    let alertController = UIAlertController(title: "User has been logged out successfully", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                    let logoutOK = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                    alertController.addAction(logoutOK)
                    self.present(alertController, animated: true, completion: nil)
                    
                })
                alertController.addAction(logoutOK)
                alertController.addAction(dismissView)
                self.present(alertController, animated: true, completion: nil)
                
            }
            else {
                
                let alertController = UIAlertController(title: "Logout failed", message: "To log out you need to be signed in", preferredStyle: UIAlertControllerStyle.alert)
                let dismissView = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
                alertController.addAction(dismissView)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        else if scene.activeGame {
            let alertController = UIAlertController(title: "Logout failed", message: "To log out you need to end the active game", preferredStyle: UIAlertControllerStyle.alert)
            let dismissView = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
            alertController.addAction(dismissView)
            self.present(alertController, animated: true, completion: nil)
        }

    }
    
    @IBAction func deleteAccount(_ sender: AnyObject) {
       
        if !scene.activeGame {
            if Reachability.isConnectedToNetwork() {
                if token != "" {
                    let alertController = UIAlertController(title: "Are you sure you want to delete the user?", message: "If the user is deleted, your score will be removed from the leader board", preferredStyle: UIAlertControllerStyle.alert)
                    let dismissView = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
                    let deleteUserOK = UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: {
                        alert in
                        
                        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
                        self.backGroundView = UIView(frame: self.view.frame)
                        self.backGroundView.center = self.view.center
                        self.backGroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
                        activityIndicator.center = self.backGroundView.center
                        self.backGroundView.addSubview(activityIndicator)
                        self.backGroundView.bringSubview(toFront: activityIndicator)
                        activityIndicator.startAnimating()
                        
                        self.view.addSubview(self.backGroundView)
                        self.view.bringSubview(toFront: self.backGroundView)
                        
                        let queue = DispatchQueue(label: "My Queue", attributes: [])
                        queue.async(execute: {
                            
                            self.username = UserDefaults.standard.value(forKey: usernameString) as! String
                            let password = KeychainWrapper().myObject(forKey: "v_Data") as! String
                            NetworkManager.deleteUser(self.username, password: password, token: token, completionHandler: self.deleteScoreHandler)
                            NetworkManager.deleteScore(self.username, token: token, completionHandler: self.deleteScoreHandler)
                            
                        })

                        
                    })
                    
                    alertController.addAction(deleteUserOK)
                    alertController.addAction(dismissView)
                    self.present(alertController, animated: true, completion: nil)
                    
                } else {
                    
                    let alertController = UIAlertController(title: "User deletion failed", message: "To delete your accout you need to be signed in", preferredStyle: UIAlertControllerStyle.alert)
                    let dismissView = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
                    alertController.addAction(dismissView)
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                
            }
            else {
                
                let alertController = UIAlertController(title: "User deletion failed", message: "To perform this action you need an internet connection", preferredStyle: UIAlertControllerStyle.alert)
                let dismissView = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
                alertController.addAction(dismissView)
                self.present(alertController, animated: true, completion: nil)
                
            }
        }
        else if scene.activeGame {
            let alertController = UIAlertController(title: "User deletion failed", message: "To delete the user you need to end the active game", preferredStyle: UIAlertControllerStyle.alert)
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
    
    //Network related methods
    fileprivate func deleteUserHandler(_ data : Data?, response : URLResponse?, error : NSError?){
        do {
            let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
            print(json)
        }
        catch {
            
        }
    }
    
    func deleteScoreHandler(_ data : Data?, response : URLResponse?, error : NSError?){
        logoutUserHandler()
        do {
            let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
            print(json)
        }
        catch {
            
        }
        DispatchQueue.main.async(execute: {
            
            self.backGroundView.removeFromSuperview()
            
            let alertController = UIAlertController(title: "User has been deleted successfully", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            let logoutOK = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alertController.addAction(logoutOK)
            self.present(alertController, animated: true, completion: nil)
        })
        
    }

    func loginHandler(_ data : Data?, response : URLResponse?, error : NSError?){
        if error == nil && data != nil {
            do {
                var json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
                token = json["token"] as! String
            } catch {
                print("Error while fetching data from mongo")
            }
        }
    }
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        
        if identifier == "privacyPolicy" {
            
            let viewController = (sender as AnyObject).destination as! PrivacyPolicyViewController
            viewController.settingsViewController = self
            addChildViewController(viewController)
            
        }
        
    }

    
}
