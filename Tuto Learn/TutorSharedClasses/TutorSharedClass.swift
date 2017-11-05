//
//  TutorSharedClass.swift
//  Tuto Learn
//
//  Created by Mahesh Kondamuri on 05/11/17.
//  Copyright © 2017 Tuto. All rights reserved.
//

import UIKit

// MARK: - Singleton
final class TutorSharedClass {
    
    // Can't init is singleton
    private init() { }
    
    // MARK: Shared Instance
    static let shared = TutorSharedClass()
    
    // MARK: Local Variables
    var loginTutorLoginObject:TutorLoginModel?
}

