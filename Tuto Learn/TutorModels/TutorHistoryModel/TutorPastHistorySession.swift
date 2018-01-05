/* 
Copyright (c) 2017 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class TutorPastHistorySession {
	public var sd_date : String?
	public var sd_start_time : String?
	public var sd_end_time : String?
	public var sd_subject : String?
	public var sd_topic : String?
	public var sd_tution_type : String?
	public var sd_grp_size : Int?
	public var sd_amt : String?
	public var sd_count : Int?
	public var tuto_name : String?
	public var rate : Int?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let session_list = Session.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Session Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [TutorPastHistorySession]
    {
        var models:[TutorPastHistorySession] = []
        for item in array
        {
            models.append(TutorPastHistorySession(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let session = Session(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Session Instance.
*/
	required public init?(dictionary: NSDictionary) {

		sd_date = dictionary["sd_date"] as? String
		sd_start_time = dictionary["sd_start_time"] as? String
		sd_end_time = dictionary["sd_end_time"] as? String
		sd_subject = dictionary["sd_subject"] as? String
		sd_topic = dictionary["sd_topic"] as? String
		sd_tution_type = dictionary["sd_tution_type"] as? String
		sd_grp_size = dictionary["sd_grp_size"] as? Int
		sd_amt = dictionary["sd_amt"] as? String
		sd_count = dictionary["sd_count"] as? Int
		tuto_name = dictionary["tuto_name"] as? String
		rate = dictionary["rate"] as? Int
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.sd_date, forKey: "sd_date")
		dictionary.setValue(self.sd_start_time, forKey: "sd_start_time")
		dictionary.setValue(self.sd_end_time, forKey: "sd_end_time")
		dictionary.setValue(self.sd_subject, forKey: "sd_subject")
		dictionary.setValue(self.sd_topic, forKey: "sd_topic")
		dictionary.setValue(self.sd_tution_type, forKey: "sd_tution_type")
		dictionary.setValue(self.sd_grp_size, forKey: "sd_grp_size")
		dictionary.setValue(self.sd_amt, forKey: "sd_amt")
		dictionary.setValue(self.sd_count, forKey: "sd_count")
		dictionary.setValue(self.tuto_name, forKey: "tuto_name")
		dictionary.setValue(self.rate, forKey: "rate")

		return dictionary
	}

}
