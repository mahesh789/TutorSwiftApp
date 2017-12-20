//
//  TutorMyAccountHeaderView.swift
//  Tuto Learn

import UIKit

class TutorMyAccountHeaderView: UITableViewHeaderFooterView {

    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var guardinNameLabel: UILabel!
    @IBOutlet weak var guardianValueLable: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    func updateheaderView(headerData:NSMutableDictionary)  {
        self.profileImageView.layer.masksToBounds = true
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height/2
    }
}
