//
//  RegistrationFooterView.swift
//  Tuto Learn
//
//  Created by Reliance Jio on 11/29/17.
//  Copyright © 2017 Tuto. All rights reserved.
//

import UIKit

class RegistrationFooterView: UIView {

    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var termAndCondition: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    func updateViewLayout()  {
        
        self.cancelButton.layer.cornerRadius = 5.0
        self.submitButton.layer.cornerRadius = 5.0;
    }
}
