//
//  Dot.swift
//  Dots
//
//  Created by Bjarte Sjursen on 30.07.2016.
//  Copyright © 2016 Sjursen Software. All rights reserved.
//

import SpriteKit

class Dot: SKShapeNode {

    override init(){
        super.init()
    }
    
    convenience init(x : CGFloat, y : CGFloat){
        
        let playerSpriteRadius = (screenSize.height/25.0)
        
        self.init(circleOfRadius: playerSpriteRadius)
        
        physicsBody = SKPhysicsBody(circleOfRadius: 15)
        fillColor = bulletFillColor
        strokeColor = bulletStrokeColor
        physicsBody?.linearDamping = 0.0
        physicsBody?.friction = 0.0
        physicsBody?.restitution = 1.0
        physicsBody?.affectedByGravity = false
        
        physicsBody!.categoryBitMask = bulletCollisionCategory
        physicsBody!.collisionBitMask =  playerCollisionCategory
        physicsBody!.contactTestBitMask =  playerCollisionCategory
        
        position.x = x
        position.y = y
        
        if(isIphone4ScreenSize){
            yScale *= 0.8
        }
        
    }
    
    func disableCollisionDetection(){
        
        if physicsBody != nil {
            
            physicsBody!.categoryBitMask = 0
            physicsBody!.collisionBitMask =  0
            physicsBody!.contactTestBitMask =  0
            
        } else {
            fatalError("physicsBody was nil when trying to use disableCollisionDetection")
        }
        
    }
    
    func enableCollisionDetection(){
        
        if physicsBody != nil {
            
            physicsBody!.categoryBitMask = bulletCollisionCategory
            physicsBody!.collisionBitMask =  playerCollisionCategory
            physicsBody!.contactTestBitMask =  playerCollisionCategory
            
        } else {
            fatalError("physicsBody was nil when trying to use enableCollisionDetection")
        }
        
    }
    
    func applyImpulse(_ dx : CGFloat, dy : CGFloat){
        
        if physicsBody != nil {
            
            let impulse = CGVector(dx: dx, dy: dy)
            physicsBody!.applyImpulse(impulse)
            
        } else {
            fatalError("physicsBody was nil when trying to use applyImpulse")
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
