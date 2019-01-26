//
//  PrivacyPolicyViewController.swift
//  Dots
//
//  Created by Bjarte Sjursen on 04.08.2016.
//  Copyright © 2016 Sjursen Software. All rights reserved.
//

import UIKit

class PrivacyPolicyViewController: UIViewController {

    var settingsViewController : SettingsViewController!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBAction func returnToSettings(_ sender: AnyObject) {

        dismiss(animated: true, completion: {})
        
    }
    
    override func viewDidLoad() {
        
        textView.dataDetectorTypes = UIDataDetectorTypes.link
        
    }
    
    
}
