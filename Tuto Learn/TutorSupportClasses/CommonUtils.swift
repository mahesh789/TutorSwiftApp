//
//  CommonUtils.swift
//  Tuto Learn
//
//  Created by Mahesh Kondamuri on 05/11/17.
//  Copyright © 2017 Tuto. All rights reserved.
//

import UIKit

extension NSString {
  func isValidEmail() -> Bool {
        let regex : NSString = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        
        return predicate.evaluate(with: self)
    }
}
