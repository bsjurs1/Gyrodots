//
//  RoundButton.swift
//  Gyroball project
//
//  Created by Bjarte Sjursen on 18.07.2016.
//  Copyright © 2016 Sjursen Software. All rights reserved.
//

import UIKit
import AudioToolbox

@IBDesignable
class RoundedButton: UIButton {
	
    var rectLayer = CAShapeLayer()
    
    @IBInspectable var circleBackgroundColor : UIColor = playButtonFillColor
    @IBInspectable var pressedCircleBackgroundColor : UIColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
    
    override func draw(_ rect: CGRect) {
        
        self.rectLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.bounds.height/2.0).cgPath
        self.rectLayer.fillColor = circleBackgroundColor.cgColor
        layer.insertSublayer(self.rectLayer, at: 0)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //Disable a button if the background is clear
		if !(UIColor.clear.cgColor == rectLayer.fillColor) {
			super.touchesBegan(touches, with: event)
			self.rectLayer.fillColor = pressedCircleBackgroundColor.cgColor
			var soundID = SystemSoundID()
			let soundPath = Bundle.main.path(forResource: "buttonpress", ofType: ".mp3")
			let soundURL = URL(fileURLWithPath: soundPath!)
			AudioServicesCreateSystemSoundID(soundURL as CFURL, &soundID)
			AudioServicesPlaySystemSound(soundID)

		}
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesEnded(touches, with: event)
        
        self.rectLayer.fillColor = circleBackgroundColor.cgColor
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    func changeAndAnimateLayerFillColorTo(_ color : UIColor){
        
        let previousColor = circleBackgroundColor
        circleBackgroundColor = color
        let colorAnimation = CABasicAnimation(keyPath: "fillColor")
        colorAnimation.duration = uiAnimationDuration
        colorAnimation.fromValue = previousColor.cgColor
        colorAnimation.toValue = color.cgColor
        rectLayer.fillColor = color.cgColor
        rectLayer.add(colorAnimation, forKey: "fillColor")
        
    }
    
}
