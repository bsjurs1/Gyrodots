//
//  ContainerViewController.swift
//  Dots
//
//  Created by Bjarte Sjursen on 01.08.2016.
//  Copyright © 2016 Sjursen Software. All rights reserved.
//

import UIKit

class ContainerViewController: VirtualPropertyParentViewController {
    
    override func viewDidLoad() {
        
        NotificationCenter.default.addObserver(gameViewController.scene, selector:#selector(gameViewController.scene.setStayPaused), name: NSNotification.Name(rawValue: "stayPausedNotification"), object: nil)
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        appDelegate.containerViewController = self
        
        view.backgroundColor = gameSceneBackgroundColor
        addChildViewController(gameViewController)
        view.addSubview(gameViewController.view)
        
        mainMenuViewController.gameViewController = gameViewController
        gameViewController.parentContainerViewController = self
        
        displayMainMenu()
        
    }
    
    func displayLeaderBoard(){
        
        let screenCenter = CGPoint(x: screenSize.width/2.0, y: screenSize.height/2.0)
        addChildViewController(leaderBoardViewController)
        view.addSubview(leaderBoardViewController.view)
        leaderBoardViewController.gameViewController = gameViewController
        leaderBoardViewController.mainMenuViewController = mainMenuViewController
        leaderBoardViewController.view.center.x = screenCenter.x
        leaderBoardViewController.view.center.y = 3*screenSize.height/2.0
        translateAndScaleViewWithAnimation(leaderBoardViewController.view, toPoint: screenCenter, byScalingFactor: 1, completionHandler: nil)
        view.bringSubview(toFront: leaderBoardViewController.backButton)
        
    }
    
    func displaySettings(){
        
        let screenCenter = CGPoint(x: screenSize.width/2.0, y: screenSize.height/2.0)
        addChildViewController(settingsViewController)
        view.addSubview(settingsViewController.view)
        settingsViewController.gameViewController = gameViewController
        settingsViewController.mainMenuViewController = mainMenuViewController
        settingsViewController.view.center.x = 3*screenSize.width/2.0
        settingsViewController.view.center.y = screenCenter.y
        translateAndScaleViewWithAnimation(settingsViewController.view, toPoint: screenCenter, byScalingFactor: 1, completionHandler: nil)
        
        
    }
    
    func hideSettings(){
        
        let translationPoint = CGPoint(x: 3*screenSize.width/2.0, y: screenSize.height/2.0)
        translateAndScaleViewWithAnimation(settingsViewController.view, toPoint: translationPoint, byScalingFactor: 1, completionHandler: {
            complete in
            self.settingsViewController.removeFromParentViewController()
            self.settingsViewController.view.removeFromSuperview()
            
        })
        
    }
    
    func hideLeaderBoard(){
        
        let translationPoint = CGPoint(x: screenSize.width/2.0, y: (3*screenSize.height/2.0))
        translateAndScaleViewWithAnimation(leaderBoardViewController.view, toPoint: translationPoint, byScalingFactor: 1, completionHandler: {
            complete in
            self.leaderBoardViewController.removeFromParentViewController()
            self.leaderBoardViewController.view.removeFromSuperview()
            
        })
        
    }
    
    func displayMainMenu(){
        addChildViewController(mainMenuViewController)
        view.addSubview(mainMenuViewController.view)
    }
    
    func hideMainMenu(){
        mainMenuViewController.view.removeFromSuperview()
    }

    
}
