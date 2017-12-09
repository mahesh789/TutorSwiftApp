//
//  TutorTimeSlotTableViewCell.swift
//  Tuto Learn
//
//  Created by Mahesh Kondamuri on 09/12/17.
//  Copyright © 2017 Tuto. All rights reserved.
//

import UIKit

class TutorTimeSlotTableViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var timeSlotCollectionView:UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.timeSlotCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TutorTimeSlotCollectionViewCell", for: indexPath) as! TutorTimeSlotCollectionViewCell
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor (red: 58.0/255.0, green: 184.0/255.0, blue: 174/255.0, alpha: 1.0)
            cell.availabLeStatusImageView.image = UIImage(named:"checkMark")
        } else {
            cell.backgroundColor = UIColor (red: 231.0/255.0, green: 118.0/255.0, blue: 60/255.0, alpha: 1.0)
            cell.availabLeStatusImageView.image = UIImage(named:"cross")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((collectionView.frame.size.width/3)-0.5), height: 74)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}