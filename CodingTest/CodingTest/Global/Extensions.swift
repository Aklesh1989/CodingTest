//
//  Extensions.swift
//  CodingTest
//
//  Created by Aklesh on 21/11/20.
//

import UIKit
import Foundation


extension NSObject {
    class var nameOfClass: String
    {
        let componentsList = NSStringFromClass(self).split(separator: ".").map(String.init)
        return componentsList.last!
    }
}

public extension String {
  
      func convertToDate() -> String{
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
          dateFormatter.locale = Locale(identifier: "en_US_POSIX")
          let date = dateFormatter.date(from: self)
          dateFormatter.calendar = Calendar(identifier: Calendar.current.identifier)
          dateFormatter.dateFormat = "MMM dd,yyyy HH:mm:ss"
          return dateFormatter.string(from: date ?? Date())
      }
  
    func convertToDate() -> Date{
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
      dateFormatter.locale = Locale(identifier: "en_US_POSIX")
      let date = dateFormatter.date(from: self)
      //print("converted date is \(date)")
      return date ?? Date()
  }
  
}


