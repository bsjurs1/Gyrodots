//
//  PlayerDot.swift
//  Dots
//
//  Created by Bjarte Sjursen on 30.07.2016.
//  Copyright © 2016 Sjursen Software. All rights reserved.
//

import SpriteKit

class PlayerDot: SKShapeNode {

    override init(){
        super.init()
    }
    
    convenience init(x : CGFloat, y : CGFloat){
        
        let playerSpriteRadius = CGFloat((screenSize.height/6.0))
        
        self.init(circleOfRadius: playerSpriteRadius)
        
        strokeColor = playerSpriteStrokeColor
        fillColor = playerSpriteFillColor
        physicsBody = SKPhysicsBody(circleOfRadius: playerSpriteRadius)
        physicsBody!.isDynamic = true
        physicsBody!.affectedByGravity = false
        physicsBody!.categoryBitMask = playerCollisionCategory
        physicsBody!.collisionBitMask =  bulletCollisionCategory
        physicsBody!.contactTestBitMask =  bulletCollisionCategory
        physicsBody?.restitution = 0.0
        physicsBody!.linearDamping = 0.5
        physicsBody?.allowsRotation = false
        physicsBody?.friction = 0.0
        setScale(3*0.4)
        
        if(isIphone4ScreenSize){
            yScale *= 0.8
        }
        
        position.x = x
        position.y = y
        
        physicsBody?.mass = 0.78539818523143
        
    }
    
    func resetPhysics(){
        
        enableCollisionDetection()
        
        if physicsBody != nil {
            physicsBody?.velocity.dx = 0
            physicsBody?.velocity.dy = 0
            physicsBody?.isDynamic = false
            physicsBody?.isDynamic = true
        } else {
            fatalError("physicsBody was nil when trying to use resetPhysics")
        }

    }

    
    func disableCollisionDetection(){
        
        if physicsBody != nil {
            physicsBody!.categoryBitMask = 0
            physicsBody!.collisionBitMask =  0
            physicsBody!.contactTestBitMask =  0
        } else {
            fatalError("Physics body was nil when trying to use disableCollisionDetection")
        }
        
    }
    
    func enableCollisionDetection(){
        
        if physicsBody != nil {
            physicsBody!.categoryBitMask = playerCollisionCategory
            physicsBody!.collisionBitMask =  bulletCollisionCategory
            physicsBody!.contactTestBitMask =  bulletCollisionCategory
        } else {
            fatalError("Physics body was nil when trying to use enableCollisionDetection")
        }

    }
    
    func applyImpulse(_ dx : CGFloat, dy : CGFloat){
        
        if physicsBody != nil {
            
            let impulse = CGVector(dx: dx, dy: dy)
            physicsBody!.applyImpulse(impulse)
            
        } else {
            fatalError("Physics body was nil when trying to use applyImpulse")
        }
        
    }
    
    func moveTo(_ x : CGFloat, y : CGFloat, duration : TimeInterval, completionHandler : @escaping () -> Void){
        
        if physicsBody != nil {
            
            let location = CGPoint(x: x, y: y)
            
            let action = SKAction.move(to: location, duration: duration)
            
            run(action, completion: completionHandler)
            
            
        } else {
            fatalError("Physics body was nil when trying to use moveTo")
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
