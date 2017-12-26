//
//  TutorHistoryTableViewCell.swift
//  Tuto Learn
//
//  Created by Mahesh Kondamuri on 14/12/17.
//  Copyright © 2017 Tuto. All rights reserved.
//

import UIKit
import Cosmos

class TutorHistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var subjectValueLabel:UILabel!
    @IBOutlet weak var topicValueLabel:UILabel!
    @IBOutlet weak var sessionValueLabel:UILabel!
    @IBOutlet weak var dateValueLabel:UILabel!
    @IBOutlet weak var timeValueLabel:UILabel!
    @IBOutlet weak var paymentValueLabel:UILabel!
    @IBOutlet weak var tutorValueLabel:UILabel!
    @IBOutlet weak var cosmosViewFull: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
