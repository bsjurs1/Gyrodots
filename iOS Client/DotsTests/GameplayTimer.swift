//
//  GameplayTimer.swift
//  Dots
//
//  Created by Bjarte Sjursen on 30.07.2016.
//  Copyright © 2016 Sjursen Software. All rights reserved.
//

import Foundation
import UIKit

class GameplayTimer {
    
    fileprivate var button : RoundedButton
    var counter = 0.0
    fileprivate var timer : Timer?
    fileprivate var timePassed = Date()
    fileprivate var timeInterval : TimeInterval
    fileprivate var gameScene : GameScene
    
    init(button : RoundedButton, inputTimeInterval : TimeInterval, scene : GameScene){
        
        self.button = button
        self.timeInterval = inputTimeInterval
        self.gameScene = scene
        
    }
    
    func clearCounter(){
        counter = 0.0
        updateLabel()
    }
    
    func timerInvocationHandler(){
        
        incrementCounter()
        
    }
    
    func incrementCounter(){
        
        if timer != nil {
            counter += timeInterval
        } else {
            fatalError("Tried to use incrementCounter when timer was nil")
        }
        
        updateLabel()
        
    }
    
    func decrementCounter(){
        
        if timer != nil {
            counter -= timeInterval
        } else {
            fatalError("Tried to use incrementCounter when timer was nil")
        }
        
        updateLabel()
    }
    
    func updateLabel(){
        
        UIView.setAnimationsEnabled(false)
        button.setTitle("\(Int(counter))", for: UIControlState())
        button.layoutIfNeeded()
        UIView.setAnimationsEnabled(true)
        
    }
    
    func pause(){
        
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
        
    }
    
    func stop(){
        
        pause()
        clearCounter()
        
    }
    
    func resume(){
        
        if timer == nil {
            self.timer = Timer(timeInterval: timeInterval, target: gameScene, selector: #selector(gameScene.timerInvocationHandler) , userInfo: nil, repeats: true)
            RunLoop.current.add(self.timer!, forMode: RunLoopMode.defaultRunLoopMode)
        }
        
    }
    
    func hide(){
        button.isHidden = true
    }
    
    func display(){
        button.isHidden = false
    }
    
}
