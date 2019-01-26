//
//  LeaderBoardViewController.swift
//  Dots
//
//  Created by Bjarte Sjursen on 29.07.2016.
//  Copyright © 2016 Sjursen Software. All rights reserved.
//

import UIKit

class LeaderBoardViewController: VirtualPropertyParentViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var backButton: RoundedButton!
    @IBOutlet weak var internetConnectionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var leaderBoardLabel: UILabel!
    var scores = Array<Dictionary<String, AnyObject>>()
    var speechBubble : UIImageView!
    var usernameLabel : UILabel!
    var scoreLabel : UILabel!
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        addSpeechBubble()
        view.bringSubview(toFront: backButton)
        
    }
    
    func addSpeechBubble(){
        speechBubble = UIImageView(image: UIImage(named: "speech"))
        speechBubble.frame.size.height = 200
        speechBubble.frame.size.width = 270
        
        usernameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 21))
        usernameLabel.center = speechBubble.center
        usernameLabel.center.y = speechBubble.center.y - 20
        usernameLabel.adjustsFontSizeToFitWidth = true
        usernameLabel.textAlignment = NSTextAlignment.center
        
        scoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 71, height: 21))
        scoreLabel.center = speechBubble.center
        scoreLabel.center.y = speechBubble.center.y + 10
        scoreLabel.adjustsFontSizeToFitWidth = true
        scoreLabel.font = UIFont.boldSystemFont(ofSize: 17)
        scoreLabel.textAlignment = NSTextAlignment.center
        
        speechBubble.addSubview(usernameLabel)
        speechBubble.addSubview(scoreLabel)
        let startPoint = CGPoint(x: screenSize.width + 400, y: screenSize.height + 400)
        speechBubble.center = startPoint
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(displaySpeechBubble))
        speechBubble.addGestureRecognizer(tapGestureRecognizer)
        speechBubble.isUserInteractionEnabled = true
        
        view.addSubview(speechBubble)
    }
    
    func displaySpeechBubble(){
        
        if speechBubble.center == view.center {
            
            let endPoint = CGPoint(x: screenSize.width - 40, y: screenSize.height - 40)
            translateAndScaleViewWithAnimation(speechBubble, toPoint: endPoint, byScalingFactor: 1, completionHandler: nil)
            
        } else {

            translateAndScaleViewWithAnimation(speechBubble, toPoint: view.center, byScalingFactor: 1.5, completionHandler: nil)
            
        }
        
    }

    func displayScore(){
        
        let hasLoginKey = UserDefaults.standard.bool(forKey: hasLoginKeyString)
        
        if hasLoginKey {
            
            let username = UserDefaults.standard.string(forKey: usernameString)!
            let score = UserDefaults.standard.integer(forKey: myScoreString)
            usernameLabel.text = "\(username)'s top-score is"
            scoreLabel.text = "\(score) sec"
            
        } else {
            
            usernameLabel.text = "Login to view top-score"
            scoreLabel.text = ""
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if Reachability.isConnectedToNetwork() {
            
            internetConnectionLabel.isHidden = true
            tableView.isHidden = false
            
            if token == "" {
                
                let hasLoginKey = UserDefaults.standard.bool(forKey: hasLoginKeyString)
                if hasLoginKey == true {
                    let username = UserDefaults.standard.string(forKey: usernameString)!
                    let password = KeychainWrapper().myObject(forKey: "v_Data") as! String
                    NetworkManager.login(username, password: password, completionHandler: loginHandler)
                }
            }
            
            else if token != "" {
                
                activityIndicator.center = view.center
                view.addSubview(activityIndicator)
                view.bringSubview(toFront: activityIndicator)
                activityIndicator.startAnimating()
                
                let queue = DispatchQueue(label: "My Queue", attributes: [])
                queue.async(execute: {
                    
                    NetworkManager.getScores(self.getScoresHandler)
                    
                    DispatchQueue.main.async(execute: {
                        self.displayScore()
                        self.speechBubble.isHidden = false
                        let startPoint = CGPoint(x: screenSize.width + 400, y: screenSize.height + 400)
                        self.speechBubble.center = startPoint
                        let endPoint = CGPoint(x: screenSize.width - 40, y: screenSize.height - 40)
                        self.translateViewWithAnimation(self.speechBubble, toPoint: endPoint, duration: 1.5)
                    })
                    
                })

            }
        
            if token == "" {
                
                speechBubble.isHidden = true
                loginViewController.leaderBoardViewController = self
                addChildViewController(loginViewController)
                view.addSubview(loginViewController.view)
                loginViewController.view.bringSubview(toFront: backButton)
                
            }

        }
        else {
            
            displayScore()
            internetConnectionLabel.isHidden = false
            tableView.isHidden = true
            
        }
        
    }
    
    //Tableview Delegate methods
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "scoreCell") as! LeaderBoardTableViewCell
        cell.tableView = tableView
        cell.placeLabel.text = "\(indexPath.row+1)."
        cell.usernameLabel.text = (scores[indexPath.row]["username"] as! String)
        cell.scoreLabel.text = String(scores[indexPath.row]["score"] as! Int) + " sec"
        
        return cell
        
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scores.count
    }
    
    fileprivate func getScoresHandler(_ data : Data?, response : URLResponse?, error : NSError?){
        if error == nil && data != nil {
            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? Array<Dictionary<String, AnyObject>> {
                    scores = json
                } else if let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? Dictionary<String, AnyObject> {
                    
                    if(json["message"] as? String == "no scores in database"){
                        return
                    } else {
                        scores.append(json)
                    }
                }
                
                
                DispatchQueue.main.async(execute: {
                    self.scores.sort(by: {$0["score"] as! Int > $1["score"] as! Int})
                    self.tableView.reloadData()
                    self.tableView.setNeedsDisplay()
                    self.activityIndicator.removeFromSuperview()
                })
                
            } catch {
                print("Error while fetching data from mongo")
            }
        }
        
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

    @IBAction func returnToMenu(_ sender: AnyObject) {
        
        mainMenuViewController.returnToMainMenu()
        
    }
    
    
}
