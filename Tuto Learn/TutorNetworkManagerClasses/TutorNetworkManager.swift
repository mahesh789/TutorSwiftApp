//
//  TutorNetworkManager.swift
//  Tuto Learn
//
//  Created by Mahesh Kondamuri on 13/11/17.
//  Copyright © 2017 Tuto. All rights reserved.
//

import UIKit
import Alamofire

class TutorNetworkManager: NSObject {

  public class func performRequestWithUrl(baseUrl:String,parametersDictionary:Dictionary<String,Any>?,completionHandler: @escaping (NSInteger?,Any?) -> Void) {
        Alamofire.request(baseUrl, method: .post, parameters:parametersDictionary, encoding: JSONEncoding.default, headers:["Content-Type":"application/json","Authorization":String(format:"Bearer %@",TutorSharedClass.shared.token ?? "")])
            .responseJSON { response in
                if response.result.isSuccess
                {
                    print(response.result.value ?? "")
                    if let resultDictionary = response.result.value as? NSDictionary
                    {
                        if Int(truncating: resultDictionary["status"] as! NSNumber) == Constants.Status.StatusOK.rawValue
                        {
                             completionHandler(Constants.Status.StatusOK.rawValue,resultDictionary)
                        }else if Int(truncating: resultDictionary["status"] as! NSNumber) == Constants.Status.TokenInvalid.rawValue
                        {
                            //need to push login controller
                            self.setrootViewControllerTaokenFailed()
                        }else{
                            completionHandler(Int(truncating: resultDictionary["status"] as! NSNumber),resultDictionary)
                        }
                    }
                }else if response.result.isFailure
                {
                    print(response.result.error as Any)
                   completionHandler(Constants.Status.serverInvalid.rawValue,nil)
                }
        }
    }
    
   class func setrootViewControllerTaokenFailed() -> Void {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tutorLoginViewController:ViewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let navigationController = UINavigationController(rootViewController: tutorLoginViewController)
        navigationController.isNavigationBarHidden = true
        UIApplication.shared.keyWindow?.rootViewController = navigationController
    }
    
}
