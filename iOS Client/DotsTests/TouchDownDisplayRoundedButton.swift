//
//  TouchDownDisplayRoundedButton.swift
//  Dots
//
//  Created by Bjarte Sjursen on 02.08.2016.
//  Copyright © 2016 Sjursen Software. All rights reserved.
//

import UIKit

class TouchDownDisplayRoundedButton: RoundedButton {
    
    var speechImageView: UIImageView?
    var usernameLabel : UILabel?
    var scoreLabel : UILabel?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        
        if speechImageView != nil {
            speechImageView?.isHidden = false
        }
        
        if usernameLabel != nil {
            usernameLabel?.isHidden = false
        }
        
        if scoreLabel != nil {
            scoreLabel?.isHidden = false
        }
        
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        super.touchesEnded(touches, with: event)
        
        if speechImageView != nil {
            speechImageView?.isHidden = true
        }
        
        if usernameLabel != nil {
            usernameLabel?.isHidden = true
        }
        
        if scoreLabel != nil {
            scoreLabel?.isHidden = true
        }

        
    }
    
}
