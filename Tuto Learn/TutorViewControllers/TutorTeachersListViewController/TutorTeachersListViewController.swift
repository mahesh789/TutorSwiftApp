//
//  TutorTeachersListViewController.swift
//  Tuto Learn
//
//  Created by Mahesh Kondamuri on 11/11/17.
//  Copyright © 2017 Tuto. All rights reserved.
//

import UIKit

class TutorTeachersListViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
   
    
@IBOutlet weak var tutorHomeNavigationBar:TutorHomeNavigationBar!
    @IBOutlet weak var teachersListCollectionView:UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setLayoutAndSetTexts()
    }
    
    func setLayoutAndSetTexts() -> Void {
        self.tutorHomeNavigationBar.leftBarButton.addTarget(self, action: #selector(backBarButtonAction), for:.touchUpInside)
        self.tutorHomeNavigationBar.rightBarButton.isHidden = true
        self.tutorHomeNavigationBar.navigationTitleLabel.text = "Find a Tutor"
        self.view.backgroundColor = UIColor.tutorAppBackgroungColor()
        self.teachersListCollectionView.backgroundColor = UIColor.tutorAppBackgroungColor()
    }
    
    @objc func backBarButtonAction() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: UICollectionView Delegate & Data Source Methods
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 10
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeachersCell", for: indexPath)
        cell.contentView.layer.cornerRadius = 5.0
        cell.contentView.layer.borderColor = UIColor.white.cgColor
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.backgroundColor = UIColor.tutorAppBackgroungColor()
        return cell
    }
    
   public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width:((collectionView.frame.size.width)/2)-10, height:350)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 20
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
