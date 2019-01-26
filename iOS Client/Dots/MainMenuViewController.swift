//
//  MainMenuViewController.swift
//  Dots
//
//  Created by Bjarte Sjursen on 29.07.2016.
//  Copyright © 2016 Sjursen Software. All rights reserved.
//

import UIKit
import SpriteKit

class MainMenuViewController: VirtualPropertyParentViewController {

    @IBOutlet weak var playButton: RoundedButton!
    @IBOutlet weak var leaderBoardButton: RoundedButton!
    @IBOutlet weak var settingsButton: RoundedButton!
    var playButtonOrigin, leaderBoardButtonOrigin, settingsButtonOrigin, replayButtonOrigin, stopButtonOrigin : CGPoint!
    
    var scene : GameScene {
        get {
            return gameViewController.scene
        }
        set {
            gameViewController.scene = newValue
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        leaderBoardButtonOrigin = CGPoint(x: screenSize.width/2.0, y: screenSize.height/2.0)
        playButtonOrigin = CGPoint(x: (screenSize.width/2.0) - 8 - playButton.bounds.height , y: screenSize.height/2.0)
        settingsButtonOrigin = CGPoint(x: (screenSize.width/2.0) + 8 + playButton.bounds.height , y: screenSize.height/2.0)

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if scene.activeGame {
            scene.isPaused = true
        } else {
            scene.isPaused = false
        }
    }

    
    @IBAction func play(_ sender: AnyObject) {
        
        if playButton.center.y != 40 {
            
            scene.playerDot.resetPhysics()
            gameViewController.startGame()
            removeFromParentViewController()
            view.removeFromSuperview()
            
        } else {
            
            gameViewController.displayScore()
            
            let playButtonTranslationPoint = playButtonOrigin
            translateAndScaleViewWithAnimation(playButton, toPoint: playButtonTranslationPoint!, byScalingFactor: 1, completionHandler: nil)
            
            let settingsButtonTranslationPoint = settingsButtonOrigin
            translateAndScaleViewWithAnimation(settingsButton, toPoint: settingsButtonTranslationPoint!, byScalingFactor: 1, completionHandler: nil)
            
            let leaderBoardButtonTranslationPoint = leaderBoardButtonOrigin
            translateAndScaleViewWithAnimation(leaderBoardButton, toPoint: leaderBoardButtonTranslationPoint!, byScalingFactor: 1, completionHandler: nil)
            
            gameViewController.parentContainerViewController.hideLeaderBoard()
            
            let translationPoint = CGPoint(x: screenSize.width/2.0, y: screenSize.height/2.0)
            translateAndScaleViewWithAnimation(scene.view!, toPoint: translationPoint, byScalingFactor: 1, completionHandler: nil)
            
            leaderBoardButton.changeAndAnimateLayerFillColorTo(playButtonFillColor)
            settingsButton.changeAndAnimateLayerFillColorTo(playButtonFillColor)

        }
        
    }
    
    @IBAction func leaderBoard(_ sender: AnyObject) {
        
        let playButtonTranslationPoint = CGPoint(x: -200, y: 40)
        let settingsButtonTranslationPoint = CGPoint(x: screenSize.width + 200, y: 40)
        let leaderBoardButtonTranslationPoint = CGPoint(x: (screenSize.width/2.0) - 80, y: 30)
        
        translateButtons(playButtonTranslationPoint, leaderBoardButtonPoint: leaderBoardButtonTranslationPoint, settingsButtonPoint: settingsButtonTranslationPoint)
        
        gameViewController.parentContainerViewController.displayLeaderBoard()
        gameViewController.parentContainerViewController.hideSettings()
        
        leaderBoardButton.changeAndAnimateLayerFillColorTo(UIColor.clear)
        settingsButton.changeAndAnimateLayerFillColorTo(playButtonFillColor)
        
        let translationPoint = CGPoint(x: -screenSize.width, y: screenSize.height/2.0)
        
        translateAndScaleViewWithAnimation(scene.view!, toPoint: translationPoint, byScalingFactor: 1, completionHandler: nil)
        
    }
    
    @IBAction func settings(_ sender: AnyObject) {
        
        let playButtonTranslationPoint = CGPoint(x: -screenSize.height, y: 40)
        let settingsButtonTranslationPoint = CGPoint(x: (screenSize.width/2.0) - 50, y: 30)
        let leaderBoardButtonTranslationPoint = CGPoint(x: -200, y: 40)
        
        translateButtons(playButtonTranslationPoint, leaderBoardButtonPoint: leaderBoardButtonTranslationPoint, settingsButtonPoint: settingsButtonTranslationPoint)
        
        gameViewController.parentContainerViewController.hideLeaderBoard()
        gameViewController.parentContainerViewController.displaySettings()
        
        let translationPoint = CGPoint(x: -screenSize.width, y: screenSize.height/2.0)
        translateAndScaleViewWithAnimation(scene.view!, toPoint: translationPoint, byScalingFactor: 1, completionHandler: nil)
        
        leaderBoardButton.changeAndAnimateLayerFillColorTo(playButtonFillColor)
        settingsButton.changeAndAnimateLayerFillColorTo(UIColor.clear)
        
        
    }
    
    fileprivate func translateButtons(_ playButtonPoint : CGPoint, leaderBoardButtonPoint : CGPoint, settingsButtonPoint : CGPoint){
        
        translateAndScaleViewWithAnimation(playButton, toPoint: playButtonPoint, byScalingFactor: 0.4, completionHandler: nil)
        translateAndScaleViewWithAnimation(leaderBoardButton, toPoint: leaderBoardButtonPoint, byScalingFactor: 0.4, completionHandler: nil)
        translateAndScaleViewWithAnimation(settingsButton, toPoint: settingsButtonPoint, byScalingFactor: 0.4, completionHandler: nil)
        
    }
    
    func returnToMainMenu(){
        
        gameViewController.displayScore()
        
        let playButtonTranslationPoint = playButtonOrigin
        translateAndScaleViewWithAnimation(playButton, toPoint: playButtonTranslationPoint!, byScalingFactor: 1, completionHandler: nil)
        
        let settingsButtonTranslationPoint = settingsButtonOrigin
        translateAndScaleViewWithAnimation(settingsButton, toPoint: settingsButtonTranslationPoint!, byScalingFactor: 1, completionHandler: nil)
        
        let leaderBoardButtonTranslationPoint = leaderBoardButtonOrigin
        translateAndScaleViewWithAnimation(leaderBoardButton, toPoint: leaderBoardButtonTranslationPoint!, byScalingFactor: 1, completionHandler: nil)
        
        let translationPoint = CGPoint(x: screenSize.width/2.0, y: screenSize.height/2.0)
        translateAndScaleViewWithAnimation(scene.view!, toPoint: translationPoint, byScalingFactor: 1, completionHandler: nil)
        
        gameViewController.parentContainerViewController.hideSettings()
        gameViewController.parentContainerViewController.hideLeaderBoard()
        
        leaderBoardButton.changeAndAnimateLayerFillColorTo(playButtonFillColor)
        settingsButton.changeAndAnimateLayerFillColorTo(playButtonFillColor)
        
    }
    
    
}
