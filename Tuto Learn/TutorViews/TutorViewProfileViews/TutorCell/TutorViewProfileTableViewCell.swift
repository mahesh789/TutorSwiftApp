//
//  TutorViewProfileTableViewCell.swift
//  Tuto Learn
//
//  Created by Mahesh Kondamuri on 15/11/17.
//  Copyright © 2017 Tuto. All rights reserved.
//

import UIKit

class TutorViewProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var profileTitleLabel:UILabel!
    @IBOutlet weak var profileValueLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
