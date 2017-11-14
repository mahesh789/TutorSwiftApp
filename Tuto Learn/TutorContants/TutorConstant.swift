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
        case TokenInvalid = 404
        case serverInvalid = 1
    }
    // MARK: List of Constants
    static let baseUrl = "https://tutoruber.000webhostapp.com/auth/public/"
    static let studentLogin = "student_login"
    static let studentRegister = "student_register"
    static let socialStudentRegister = "social_student_register"
    static let token = "token"
    static let cityList = "city_list"
    static let topicList = "topic_list"
    static let editStudent = "edit_student"
    static let subjectList = "subject_list"

    static let screenSize = UIScreen.main.bounds
    static let phoneScreenWidth = screenSize.width
    static let phoneScreenHeight = screenSize.height
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

