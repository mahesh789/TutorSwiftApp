//
//  TutorSharedClass.swift
//  Tuto Learn
//
//  Created by Mahesh Kondamuri on 05/11/17.
//  Copyright © 2017 Tuto. All rights reserved.
//

import UIKit


// MARK: - Singleton
final class TutorSharedClass:NSObject {
    
    // Can't init is singleton
     override init() { }
    
    // MARK: Shared Instance
    static let shared = TutorSharedClass()
    
    // MARK: Local Variables
    var loginTutorLoginObject:TutorLoginModel?
    
    // MARK: Local Variables
    var token:String?
    var studentId:String?

     
}

