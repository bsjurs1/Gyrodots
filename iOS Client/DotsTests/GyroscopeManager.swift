//
//  GyroscopeManager.swift
//  Dots
//
//  Created by Bjarte Sjursen on 30.07.2016.
//  Copyright © 2016 Sjursen Software. All rights reserved.
//

import CoreMotion
import UIKit
import SpriteKit

class GyroscopeManager {
    
    var motionManager = CMMotionManager()
    let queue = OperationQueue.main
    var x1 = 0.0, x2 = 0.0 , y1 = 0.0, y2 = 0.0
    
    init(playerDot : PlayerDot){
        
        let thread = DispatchQueue(label: "gyroQueue", attributes: [])
        
        thread.async(execute: {
            
            self.motionManager.deviceMotionUpdateInterval = 1.0/kUpdateFrequency
            
            self.motionManager.startDeviceMotionUpdates(to: self.queue, withHandler: {
                (data, error) in
                
                self.x1 = filterConstant * (self.x1 + (-data!.gravity.y) - self.x2)
                self.y1 = filterConstant * (self.y1 + (data!.gravity.x) - self.y2)
                
                self.x2 = -data!.gravity.y
                self.y2 = data!.gravity.x
                
                //Add new impulse based on motion of phone
                let impulse = CGVector(dx: CGFloat(self.x1)*200, dy: CGFloat(self.y1)*200)
                
                if playerDot.physicsBody != nil {
                    playerDot.physicsBody!.applyImpulse(impulse)
                } else {
                    print("Player dot was nil when trying to use the gyroScope")
                }
                
                
            })

        
        })

        
    }
    
    func stopUpdates(){
        
        motionManager.stopDeviceMotionUpdates()
        
    }
    
    func startUpdates(){
        
        motionManager.startDeviceMotionUpdates()
        
    }
    
    
}
