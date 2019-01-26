//
//  TouchForwardingView.swift
//  Dots
//
//  Created by Bjarte Sjursen on 31.07.2016.
//  Copyright © 2016 Sjursen Software. All rights reserved.
//

import UIKit

class TouchForwardingView: UIView {

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews as [UIView] {
            if !subview.isHidden && subview.alpha > 0 && subview.isUserInteractionEnabled && subview.point(inside: convert(point, to: subview), with: event) {
                return true
            }
        }
        return false
    }
    
}
