
//  Comment.swift
//  CodingTest
//
//  Created by Aklesh on 17/01/21.
//

import UIKit


class Comment: NSObject, NSCoding {
  
  struct Key
   {
     fileprivate static let body  = "body"
     fileprivate static let userID = "id"
     fileprivate static let user = "user"
   }
   var userID:String!
   var body:String!


  //MARK:- init methods
  override init(){}
  
  init(fromDictionary dictionary: [String:Any]) {
    
    body = dictionary[Key.body] as? String ?? ""
    if let userDict = dictionary[Key.user] as? [String:Any] {
      userID = "\(userDict[Key.userID] ?? "Anonymous")"
    } else {
      userID = "Anonymous"
    }

  }
  
  
  func encode(with coder: NSCoder) {
    if userID != nil {
      coder.encode(userID, forKey: Key.userID)
    }
    if body != nil {
      coder.encode(body, forKey: Key.body)
    }
    
    
  }
  
  required init?(coder: NSCoder) {
    userID = coder.decodeObject(forKey: Key.userID) as? String
    body = coder.decodeObject(forKey: Key.body) as? String

  }

}

extension Comment {
  class func getAllComments(issueNumber:String, completionHandler: @escaping ([Comment]?, NSError?) -> Void) {
    
    let urlString = "/issues/\(issueNumber)/comments"
    //let https://api.github.com/repos/firebase/firebase-ios-sdk/issues/3228/comments
    _ = WebCallsHelper.callWebService(withUrlStr: urlString, httpMethod: WebCallType.get, queryParams: nil, bodyParams: nil) { (data, error) in
      if let object = data {
        if let array = object[WebCallPredefinedKeys.kData] as? [[String:Any]] {
          let movies = array.map { (object) -> Comment in
            return Comment(fromDictionary: object)
          }
          completionHandler(movies,nil)
          return
        }
        completionHandler(nil, nil)
      } else {
        completionHandler(nil, error)
      }
    }
    
  }
}
