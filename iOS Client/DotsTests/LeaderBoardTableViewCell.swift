//
//  LeaderBoardTableViewCell.swift
//  Dots
//
//  Created by Bjarte Sjursen on 29.07.2016.
//  Copyright © 2016 Sjursen Software. All rights reserved.
//

import UIKit

@IBDesignable
class LeaderBoardTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    
    var rectLayer = CAShapeLayer()
    var tableView : UITableView?
    
    override func draw(_ rect: CGRect) {
        
        if tableView != nil {
            self.rectLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 5, width: tableView!.bounds.width, height: tableView!.rowHeight-10), cornerRadius: (tableView!.rowHeight-10)/2.0).cgPath
            self.rectLayer.fillColor = playButtonFillColor.cgColor
            layer.insertSublayer(self.rectLayer, at: 0)
        }
        
    }
    
}
