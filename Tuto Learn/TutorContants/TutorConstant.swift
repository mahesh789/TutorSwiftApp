//
//  TutorConstant.swift
//  Tuto Learn
//
//  Created by Mahesh Kondamuri on 05/11/17.
//  Copyright © 2017 Tuto. All rights reserved.
//

import Foundation
import Alamofire

class Constants {
    enum Status:Int {
        case StatusOK = 200
        case TokenNotFound = 202
        case serverInvalid = 1
    }
    // MARK: List of Constants
    static let baseUrl = "https://mytestserver.tech/api/auth/public/"
    static let studentLogin = "student_login_screen"
    static let studentRegister = "student_register"
    static let socialStudentRegister = "social_student_register"
    static let updateGuardianDetails = "update_student_parents"
    static let profileDetails = "all_data_with_old_login"
    static let levelBoard = "level_board"
    static let preferenceDetails = "fetch_preference"
    static let updatePreference = "student_preference"
    static let addStudent = "add_student"
    static let getGaurdianDetailForStudent = "fetch_guardian"

    

    static let token = "token"
    static let cityList = "city_list"
    static let topicList = "topic_list"
    static let editStudent = "edit_student"
    static let subjectList = "subject_list"
    static let studentList = "select_student"
    static let searchTutor = "search_tutor"
    static let forgot_Password = "student_forgot_password"
    static let set_Forgot_Password = "set_forgot_password"
    static let timeSlotTable = "view_time_table"
    static let past_History = "past_history"
    static let upcoming_history = "upcoming_history"
    static let check_Wallet_Balance = "check_wallet_balance"
    static let make_payment = "make_payment"
    static let book_tutor = "book_tutor"
    static let store_device = "store_device"
    static let screenSize = UIScreen.main.bounds
    static let phoneScreenWidth = screenSize.width
    static let phoneScreenHeight = screenSize.height
    
    static let dateFormatValue = "yyyy-MM-dd"
    static let findTutordateFormatValue = "dd/MM/yyyy"
    
}

class TutorGenerateToken {
    class func performGenerateTokenUrl(completionHandler: @escaping (NSInteger?,String?) -> Void)
    {
        let urlPath = String(format: "%@%@",Constants.baseUrl,Constants.token) as String
        Alamofire.request(urlPath, method: .post, parameters:nil, encoding: JSONEncoding.default, headers:["Content-Type":"application/json"])
            .responseJSON { response in
                if response.result.isSuccess
                {
                    if let resultDictionary = response.result.value as? NSDictionary
                    {
                        if Int(truncating: resultDictionary["status"] as! NSNumber) == Constants.Status.StatusOK.rawValue
                        {
                            let tokenId = resultDictionary["token"] as? String
                            TutorSharedClass.shared.token = tokenId
                            completionHandler(200,tokenId)
                        }else{
                            completionHandler(201,"")
                        }
                    }else{
                        completionHandler(201,"")
                    }
                }else if response.result.isFailure
                {
                    print(response.result.error as Any)
                    completionHandler(201,"")
                }
        }
    }
}

class TutorDefaultAlertController {
    
    //MARK: Default AlertViewController
   class func showAlertController(alertMessage:String?,showController:AnyObject) -> Void {
        let alert = UIAlertController(title: "", message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        (showController as AnyObject).present(alert, animated: true, completion: nil)
    }
}

