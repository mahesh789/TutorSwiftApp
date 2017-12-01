//
//  CustomTextField.swift
//  Tuto Learn
//
//  Created by Reliance Jio on 11/23/17.
//  Copyright © 2017 Tuto. All rights reserved.
//

import UIKit
import AAPickerView

class CustomTextField: AAPickerView {

    var customTag = 0
    @IBInspectable var paddingLeft: CGFloat = 5
    @IBInspectable var paddingRight: CGFloat = 0
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + paddingLeft, y: bounds.origin.y, width: bounds.size.width - paddingLeft - paddingRight, height: bounds.size.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
}
