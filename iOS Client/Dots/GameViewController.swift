//
//  GameViewController.swift
//  Dots
//
//  Created by Bjarte Sjursen on 29.07.2016.
//  Copyright (c) 2016 Sjursen Software. All rights reserved.
//

import UIKit
import SpriteKit
import GoogleMobileAds

class GameViewController: VirtualPropertyParentViewController, GADInterstitialDelegate {

    @IBOutlet weak var okButton: RoundedButton!
    @IBOutlet weak var speechBubble: UIImageView!
    @IBOutlet weak var pauseButton: RoundedButton!
    @IBOutlet weak var replayButton: RoundedButton!
    @IBOutlet weak var stopButton: RoundedButton!
    @IBOutlet weak var gamePlayTimerButton: TouchDownDisplayRoundedButton!
    @IBOutlet weak var speechBubbleUsernameLabel: UILabel!
    @IBOutlet weak var speechBubbleScoreLabel: UILabel!
    var gameplayTimer : GameplayTimer!
    var scene = GameScene(fileNamed: "GameScene")!
    var parentContainerViewController: ContainerViewController!
    var okButtonPress = 1
    var interstitial : GADInterstitial!
    
    //Google ads
    func createAndLoadInterstitial() {
        
        let queue = DispatchQueue(label: "adQueue", attributes: [])
        queue.async(execute: {
            
            self.interstitial = GADInterstitial(adUnitID: "ca-app-pub-7280091461042882/4733371457")
            self.interstitial.delegate = self
            self.interstitial.load(GADRequest())
        
        })
    }

    func interstitialDidDismissScreen(_ ad: GADInterstitial!) {
        VirtualPropertyParentViewController.musicManager.play()
        createAndLoadInterstitial()
    }
    
    @IBAction func okButtonPress(_ sender: RoundedButton) {
        
        okButtonPress += 1
        
        scene.boardPlayer(okButtonPress)
        
    }
    
    @IBAction func showBestScore(_ sender: RoundedButton) {
        
        displayScore()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        displayScore()
        
    }
    
    func displayScore(){
        
        let hasLoginKey = UserDefaults.standard.bool(forKey: hasLoginKeyString)
        
        if hasLoginKey {
            
            let username = UserDefaults.standard.string(forKey: usernameString)!
            let score = UserDefaults.standard.integer(forKey: myScoreString)
            speechBubbleUsernameLabel.text = "\(username)'s top-score is"
            speechBubbleScoreLabel.text = "\(score) sec"
            
        } else {
            
            speechBubbleUsernameLabel.text = "Log in to view your"
            speechBubbleScoreLabel.text = "top-score"
        }

        
    }
    
    @IBAction func pause(_ sender: AnyObject) {
        
        pause()
        
    }
    
    func pause(){
        
        scene.pauseGame()
        parentContainerViewController.displayMainMenu()
        gameplayTimer.hide()
        pauseButton.isHidden = true
        replayButton.isHidden = false
        stopButton.isHidden = false
        view.bringSubview(toFront: stopButton)
        view.bringSubview(toFront: replayButton)
        VirtualPropertyParentViewController.musicManager.pause()
        
    }
    
    @IBAction func stop(_ sender: AnyObject) {

        pauseButton.isHidden = true
        replayButton.isHidden = true
        stopButton.isHidden = true
        gameplayTimer.hide()
        parentContainerViewController.displayMainMenu()
        scene.stopGame()
        VirtualPropertyParentViewController.musicManager.pause()
    }
    
    @IBAction func replay(_ sender: AnyObject) {
        
        scene.restartGame()
        pauseButton.isHidden = false
        replayButton.isHidden = true
        stopButton.isHidden = true
        gameplayTimer.display()
        parentContainerViewController.hideMainMenu()
        VirtualPropertyParentViewController.musicManager.play()
        
    }
    
    func gameOver(){
        
        let gamesPlayed = UserDefaults.standard.integer(forKey: numberOfTimesPlayedString)
        
        if interstitial == nil {
            createAndLoadInterstitial()
        } else if interstitial != nil {
            if interstitial.isReady && gamesPlayed%5 == 0 && gamesPlayed>=10 {
                interstitial.present(fromRootViewController: self)
                VirtualPropertyParentViewController.musicManager.pause()
            }

        }
        // Give user the option to start the next game.
        
        replayButton.isHidden = false
        stopButton.isHidden = false
        pauseButton.isHidden = true
        
    }
    
    func startGame(){
        
        scene.startGame()
        gameplayTimer.display()
        pauseButton.isHidden = false
        replayButton.isHidden = true
        stopButton.isHidden = true
        VirtualPropertyParentViewController.musicManager.play()
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        okButton.isHidden = true
        speechBubble.isHidden = true
        speechBubbleUsernameLabel.isHidden = true
        speechBubbleScoreLabel.isHidden = true
        gamePlayTimerButton.speechImageView = speechBubble
        gamePlayTimerButton.usernameLabel = speechBubbleUsernameLabel
        gamePlayTimerButton.scoreLabel = speechBubbleScoreLabel
        speechBubbleUsernameLabel.adjustsFontSizeToFitWidth = true
        view.bringSubview(toFront: speechBubbleScoreLabel)
        view.bringSubview(toFront: speechBubbleUsernameLabel)
        displayScore()

        // Configure the view.
        let skView = self.view as! SKView
        //skView.showsFPS = true
        //skView.showsNodeCount = truer
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .fill
        
        skView.presentScene(scene)
        scene.parentViewController = self
        
        gameplayTimer = GameplayTimer(button: gamePlayTimerButton, inputTimeInterval: 1, scene: scene)
        NotificationCenter.default.addObserver(scene, selector:#selector(scene.setStayPaused), name: NSNotification.Name(rawValue: "stayPausedNotification"), object: nil)
        
        replayButton.isHidden = true
        stopButton.isHidden = true
        gamePlayTimerButton.isHidden = true
        pauseButton.isHidden = true
        
        
    }

}
