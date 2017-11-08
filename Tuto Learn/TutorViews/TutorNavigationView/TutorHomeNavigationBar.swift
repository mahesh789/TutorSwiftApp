//
//  TutorHomeNavigationBar.swift
//  Tuto Learn
//
//  Created by Mahesh Kondamuri on 06/11/17.
//  Copyright © 2017 Tuto. All rights reserved.
//

import UIKit

class TutorHomeNavigationBar: UIView {

 public var leftBarButton:UIButton!
 public var rightBarButton:UIButton!
 public var navigationTitleLabel: UILabel!
    
    override func awakeFromNib() {
        self.layoutContent()
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        }
    func layoutContent() -> Void {
        let navigationBarView = UIView()
        navigationBarView.frame = CGRect(x: 0, y: 0, width: Constants.phoneScreenWidth, height: 76)
        navigationBarView.backgroundColor = UIColor.navigationBarColor()
        self.addSubview(navigationBarView)
        
        //Navigation Title
        navigationTitleLabel = UILabel.init(frame: CGRect(x:0,y: 18+(76-44-20)/2.0, width: Constants.phoneScreenWidth, height: 44))
        navigationTitleLabel.backgroundColor = UIColor.clear
        navigationTitleLabel.textAlignment = .center
        navigationTitleLabel.textColor = UIColor.navigationTitleColor()
        navigationTitleLabel.font = UIFont(name: navigationTitleLabel.font.fontName, size: 20)
        navigationBarView.addSubview(navigationTitleLabel)
        
        //left arrow_icon
        leftBarButton = UIButton.init(frame: CGRect(x:10,y: 20+(76-40-20)/2.0, width: 40, height: 40))
        leftBarButton.setImage(UIImage(named: "arrow_icon"), for: UIControlState.normal)
        navigationBarView.addSubview(leftBarButton)
        //right arrow_icon
        rightBarButton = UIButton.init(frame: CGRect(x:(Constants.phoneScreenWidth-50),y: 20+(76-30-20)/2.0, width: 30, height: 30))
        rightBarButton.setImage(UIImage(named: "menu"), for: UIControlState.normal)
        navigationBarView.addSubview(rightBarButton)
    }

}
