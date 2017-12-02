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

    func updateLayout(registrationData:NSDictionary,cellType:RegistrationCellType) {
        
        leftTextField.placeholder = registrationData.value(forKey: "leftTitle") as? String
        rightTextField.placeholder = registrationData.value(forKey: "rightTitle") as? String
        
        leftTextField.text = registrationData.value(forKey: "leftValue") as? String
        rightTextField.text = registrationData.value(forKey: "rightValue") as? String
        
        leftTextField.customTag = 1
        rightTextField.customTag = 2
        rightDropImageView.isHidden = true
        leftDropImageView.isHidden = true
        if(cellType.rawValue == RegistrationCellType.RegistrationCellTypeRegistration.rawValue)
        {
            self.setLayoutForRegistration(registrationData: registrationData)
        }else if(cellType.rawValue == RegistrationCellType.RegistrationCellTypeGuardianProfile.rawValue)
        {
            self.setLayoutForGuardianProfile(registrationData: registrationData)
        }
    }
    
    func setLayoutForRegistration(registrationData:NSDictionary) {
        
        if registrationData.value(forKey: "type") as? Int == RegistrationDataType.RegistrationDataTypeGender.rawValue
        {
            rightDropImageView.isHidden = false
            leftDropImageView.isHidden = false
        }
        
        if registrationData.value(forKey: "type") as? Int == RegistrationDataType.RegistrationDataTypeDistrict.rawValue
        {
            leftDropImageView.isHidden = false
        }
        if registrationData.value(forKey: "type") as? Int == RegistrationDataType.RegistrationDataTypeMobile.rawValue || registrationData.value(forKey: "type") as? Int == RegistrationDataType.RegistrationDataTypePincode.rawValue
        {
            leftTextField.keyboardType = .numberPad
        }else
        {
            leftTextField.keyboardType = .default
        }
        
        if registrationData.value(forKey: "type") as? Int == RegistrationDataType.RegistrationDataTypePassword.rawValue
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
        if registrationData.value(forKey: "type") as? Int == RegistrationDataType.RegistrationDataTypeAddress1.rawValue || registrationData.value(forKey: "type") as? Int == RegistrationDataType.RegistrationDataTypeAddress2.rawValue || registrationData.value(forKey: "type") as? Int == RegistrationDataType.RegistrationDataTypeEmail.rawValue
        {
            self.leftTextFieldcontraint.constant = -(self.frame.size.width - 40)
            rightTextField.isHidden = true
        }else
        {
            self.leftTextFieldcontraint.constant = 20
            rightTextField.isHidden = false
        }
        
        if registrationData.value(forKey: "type") as? Int == RegistrationDataType.RegistrationDataTypeEmail.rawValue || registrationData.value(forKey: "type") as? Int == RegistrationDataType.RegistrationDataTypeDistrict.rawValue || registrationData.value(forKey: "type") as? Int == RegistrationDataType.RegistrationDataTypePincode.rawValue
        {
            rightTextField.isHidden = true
        }else
        {
            rightTextField.isHidden = false
        }
    }
    
    func setLayoutForGuardianProfile(registrationData:NSDictionary) {
        
        if registrationData.value(forKey: "type") as? Int == ProfileDataType.ProfileDataTypeGender.rawValue
        {
            rightDropImageView.isHidden = false
            leftDropImageView.isHidden = false
        }
        
        if registrationData.value(forKey: "type") as? Int == ProfileDataType.ProfileDataTypeMobile.rawValue
        {
            leftTextField.keyboardType = .numberPad
        }else
        {
            leftTextField.keyboardType = .default
        }
        
        self.bottomLabelcontraint.constant = -15
        bottomLabel.isHidden = true
        leftTextField.isSecureTextEntry = false
        rightTextField.isSecureTextEntry = false
        
        if registrationData.value(forKey: "type") as? Int == ProfileDataType.ProfileDataTypeOccupation.rawValue ||  registrationData.value(forKey: "type") as? Int == ProfileDataType.ProfileDataTypeEmail.rawValue
        {
            self.leftTextFieldcontraint.constant = -(self.frame.size.width - 40)
            rightTextField.isHidden = true
        }else
        {
            self.leftTextFieldcontraint.constant = 20
            rightTextField.isHidden = false
        }
        
        if registrationData.value(forKey: "type") as? Int == ProfileDataType.ProfileDataTypeMobile.rawValue
        {
            rightTextField.isHidden = true
        }else
        {
            rightTextField.isHidden = false
        }
    }
}
