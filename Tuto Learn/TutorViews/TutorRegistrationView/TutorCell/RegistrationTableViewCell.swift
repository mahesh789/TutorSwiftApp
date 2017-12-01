//
//  RegistrationTableViewCell.swift
//  Tuto Learn
//
//  Created by Reliance Jio on 11/27/17.
//  Copyright © 2017 Tuto. All rights reserved.
//

import UIKit

class RegistrationTableViewCell: UITableViewCell {

    
    @IBOutlet weak var leftTextField: CustomTextField!
    @IBOutlet weak var rightTextField: CustomTextField!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var bottomLabelcontraint: NSLayoutConstraint!
    @IBOutlet weak var leftTextFieldcontraint: NSLayoutConstraint!
    @IBOutlet weak var leftDropImageView: UIImageView!
    @IBOutlet weak var rightDropImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateLayout(registrationData:NSDictionary) {
        
        leftTextField.placeholder = registrationData.value(forKey: "leftTitle") as? String
        rightTextField.placeholder = registrationData.value(forKey: "rightTitle") as? String
        
        leftTextField.text = registrationData.value(forKey: "leftValue") as? String
        rightTextField.text = registrationData.value(forKey: "rightValue") as? String
        
        leftTextField.customTag = 1
        rightTextField.customTag = 2
        rightDropImageView.isHidden = true
        leftDropImageView.isHidden = true
        
        if registrationData.value(forKey: "type") as? String == "2"
        {
            rightDropImageView.isHidden = false
            leftDropImageView.isHidden = false
        }
        
        if registrationData.value(forKey: "type") as? String == "8"
        {
            leftDropImageView.isHidden = false
        }
        
        if registrationData.value(forKey: "type") as? String == "3" ||  registrationData.value(forKey: "type") as? String == "9"
        {
            rightTextField.keyboardType = .numberPad
        }else
        {
            rightTextField.keyboardType = .default
        }
        
        if registrationData.value(forKey: "type") as? String == "5"
        {
            self.bottomLabelcontraint.constant = 10
            bottomLabel.isHidden = false
            bottomLabel.text = registrationData.value(forKey: "bottomValue") as? String
            leftTextField.isSecureTextEntry = true
            rightTextField.isSecureTextEntry = true
        }else
        {
            self.bottomLabelcontraint.constant = -15
            bottomLabel.isHidden = true
            leftTextField.isSecureTextEntry = false
            rightTextField.isSecureTextEntry = false
        }
        if registrationData.value(forKey: "type") as? String == "6" || registrationData.value(forKey: "type") as? String == "7"
        {
            self.leftTextFieldcontraint.constant = -(self.frame.size.width - 40)
            rightTextField.isHidden = true
        }else
        {
            self.leftTextFieldcontraint.constant = 20
            rightTextField.isHidden = false
        }
        
        if registrationData.value(forKey: "type") as? String == "4" || registrationData.value(forKey: "type") as? String == "8" || registrationData.value(forKey: "type") as? String == "9"
        {
            rightTextField.isHidden = true
        }else
        {
            rightTextField.isHidden = false
        }
    }
}
