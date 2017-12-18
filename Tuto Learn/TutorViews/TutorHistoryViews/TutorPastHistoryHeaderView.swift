//
//  TutorPastHistoryHeaderView.swift
//  Tuto Learn
//
//  Created by Mahesh Kondamuri on 17/12/17.
//  Copyright © 2017 Tuto. All rights reserved.
//

import UIKit

class TutorPastHistoryHeaderView: UIView {

@IBOutlet weak var studentProfileImage: UIImageView!
@IBOutlet weak var studentName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.studentProfileImage.layer.cornerRadius = self.studentProfileImage.frame.size.height/2
        self.studentProfileImage.clipsToBounds = true
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }


}
