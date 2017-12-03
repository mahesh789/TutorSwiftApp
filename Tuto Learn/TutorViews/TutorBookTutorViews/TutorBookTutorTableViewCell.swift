//
//  TutorBookTutorTableViewCell.swift
//  Tuto Learn
//
//  Created by Mahesh Kondamuri on 03/12/17.
//  Copyright © 2017 Tuto. All rights reserved.
//

import UIKit

class TutorBookTutorTableViewCell: UITableViewCell {
    
    @IBOutlet weak var leftTitleLabel:UILabel!
    @IBOutlet weak var leftValueLabel:UILabel!
    
    @IBOutlet weak var middleTitleLabel:UILabel!
    @IBOutlet weak var middleValueLabel:UILabel!
    
    @IBOutlet weak var rightTitleLabel:UILabel!
    @IBOutlet weak var rightValueLabel:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
