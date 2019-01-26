//
//  VirtualPropertyParentViewController.swift
//  Dots
//
//  Created by Bjarte Sjursen on 29.07.2016.
//  Copyright © 2016 Sjursen Software. All rights reserved.
//

import UIKit

class VirtualPropertyParentViewController: UIViewController {
    
    static let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    lazy var gameViewController = mainStoryboard.instantiateViewController(withIdentifier: "gameViewController") as! GameViewController
    lazy var mainMenuViewController = mainStoryboard.instantiateViewController(withIdentifier: "mainMenuViewController") as! MainMenuViewController
    lazy var leaderBoardViewController = mainStoryboard.instantiateViewController(withIdentifier: "leaderBoardViewController") as! LeaderBoardViewController
    lazy var settingsViewController = mainStoryboard.instantiateViewController(withIdentifier: "settingsViewController") as! SettingsViewController
    lazy var loginViewController = mainStoryboard.instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
    lazy var registerViewController = mainStoryboard.instantiateViewController(withIdentifier: "registerViewController") as! RegisterViewController
    static var musicManager = MusicManager(nameOfSong: "Jaracanda", withExtension: ".caf")
    
    override func viewDidLoad() {
        
        view.backgroundColor = UIColor.clear
        
    }
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .landscapeRight
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }

    internal func translateAndScaleViewWithAnimation(_ view : UIView, toPoint : CGPoint, byScalingFactor : CGFloat, completionHandler : (((Bool))->Void)?){
        
        UIView.animate(withDuration: uiAnimationDuration, delay: 0, options: .curveEaseOut, animations: {
            view.center.x = toPoint.x
            view.center.y = toPoint.y
            view.transform = CGAffineTransform.identity.scaledBy(x: byScalingFactor, y: byScalingFactor)
            }, completion: completionHandler)
        
    }
    
    internal func translateViewWithAnimation(_ view : UIView, toPoint : CGPoint, duration : TimeInterval){
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            
            view.center.x = toPoint.x
            view.center.y = toPoint.y
            
            }, completion: nil)
        
    }
    
}
