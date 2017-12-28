//
//  TutorMyAccountHeaderView.swift
//  Tuto Learn

import UIKit

class TutorMyAccountHeaderView: UITableViewHeaderFooterView {

    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var guardinNameLabel: UILabel!
    @IBOutlet weak var guardianValueLable: UILabel!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var preferneceView: UIView!
    @IBOutlet weak var boarderLabel: UILabel!
    @IBOutlet weak var preferenceEditButton: UIButton!

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    func updateheaderView(headerData:NSMutableDictionary, filterData:NSMutableDictionary)  {
        
        profileView.backgroundColor = UIColor.init(red: 62, green: 144, blue: 151)
        titleView.backgroundColor = UIColor.init(red: 244, green: 244, blue: 244)

        self.profileImageView.layer.masksToBounds = true
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height/2
        if headerData.value(forKey: "type") as? String == "3"
        {
            profileView.isHidden = true
            titleView.isHidden = true
            preferneceView.isHidden = false
            boarderLabel.isHidden = true

        }else
        {
            profileView.isHidden = false
            titleView.isHidden = false
            preferneceView.isHidden = true
            boarderLabel.isHidden = false
        }
        
        if headerData.value(forKey: "type") as? String == "2"
        {
            self.guardinNameLabel.text = "\(filterData["sm_name"] as? String ?? "") \(filterData["sm_last"] as? String ?? "")"
            
            self.guardianValueLable.text = "STUDENT"
            if let profileUrl = filterData.value(forKey: "sm_profile_image") as? String
            {
                profileImageView.kf.setImage(with: URL.init(string: profileUrl) , placeholder: UIImage.init(named: "dummyPhoto"), options: nil, progressBlock: nil, completionHandler:{
                    (image, error, cacheType, imageUrl) in
                    if (image != nil)
                    {
                        
                    }
                })
            }
        }else if headerData.value(forKey: "type") as? String == "1"
        {
            self.guardianValueLable.text = "GUARDIAN"
            self.guardinNameLabel.text = headerData.value(forKey: "userName") as? String ?? ""
            if let profileUrl = headerData.value(forKey: "profileImage") as? String
            {
                profileImageView.kf.setImage(with: URL.init(string: profileUrl) , placeholder: UIImage.init(named: "dummyPhoto"), options: nil, progressBlock: nil, completionHandler:{
                    (image, error, cacheType, imageUrl) in
                    if (image != nil)
                    {
                        
                    }
                })
            }
        }

    }
}
