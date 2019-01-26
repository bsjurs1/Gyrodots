//
//  DotTarget.swift
//  Dots
//
//  Created by Bjarte Sjursen on 30.07.2016.
//  Copyright © 2016 Sjursen Software. All rights reserved.
//

import SpriteKit

class DotTarget: SKShapeNode {

    override init(){
        super.init()
    }
    
    convenience init(x : CGFloat, y : CGFloat){
        
        let playerSpriteRadius = (screenSize.height/25.0)
        
        self.init(circleOfRadius: playerSpriteRadius)
        
        fillColor = bulletTargetFillColor
        strokeColor = bulletTargetStrokeColor
        
        if(isIphone4ScreenSize){
            yScale *= 0.4
            xScale *= 1.5
        }
        
        position.x = x
        position.y = y
        
    }
    
    func fadeOutAndScale(_ completionHandler : @escaping ()->Void ){
        
        run(SKAction.scale(to: 6, duration: 1))
        run(SKAction.fadeOut(withDuration: 1), completion: completionHandler)

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
