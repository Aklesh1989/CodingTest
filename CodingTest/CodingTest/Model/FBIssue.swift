//
//  FBIssue.swift
//  CodingTest
//
//  Created by Aklesh on 17/01/21.
//

import Foundation
class FBIssue: NSObject, NSCoding {
  
  struct Key {
     fileprivate static let title  = "title"
     fileprivate static let body  = "body"
     fileprivate static let number = "number"
     fileprivate static let state  = "state"
     fileprivate static let comments  = "comments"
     fileprivate static let created_at  = "created_at"
     fileprivate static let updated_at  = "updated_at"
     fileprivate static let commentsUrl  = "comments_url"


   }
   var commentsCount:Int!
   var title:String!
   var body:String!
   var state:String!
   var number:Int!
   var created_at:String!
   var updated_at:String!
   var commentsUrl:String!
   var updatedDate:Date! {
    return updated_at.convertToDate()
   }
  
  var isOpen:Bool {
    return state == "open"
  }


  //MARK:- init methods
  override init(){}
  
  init(fromDictionary dictionary: [String:Any]) {
    
    commentsCount = dictionary[Key.comments] as? Int
    title = dictionary[Key.title] as? String ?? ""
    body = dictionary[Key.body] as? String ?? ""
    state = dictionary[Key.state] as? String ?? "closed"
    number = dictionary[Key.number] as? Int
    created_at = dictionary[Key.created_at] as? String ?? ""
    updated_at = dictionary[Key.updated_at] as? String ?? ""
    commentsUrl = dictionary[Key.commentsUrl] as? String ?? ""

  }
  
  func encode(with coder: NSCoder) {
    if commentsCount != nil {
      coder.encode(commentsCount, forKey: Key.comments)
    }
    if title != nil {
      coder.encode(title, forKey: Key.title)
    }
    if body != nil {
      coder.encode(body, forKey: Key.body)
    }
    if state != nil {
      coder.encode(state, forKey: Key.state)
    }
    if number != nil {
      coder.encode(number, forKey: Key.number)
    }
    if created_at != nil {
      coder.encode(created_at, forKey: Key.created_at)
    }
    
    if updated_at != nil {
      coder.encode(updated_at, forKey: Key.updated_at)
    }
    if commentsUrl != nil {
      coder.encode(commentsUrl, forKey: Key.commentsUrl)
    }
    
  }
  
  required init?(coder: NSCoder) {
    commentsCount = coder.decodeObject(forKey: Key.comments) as? Int
    title = coder.decodeObject(forKey: Key.title) as? String
    body = coder.decodeObject(forKey: Key.body) as? String
    state = coder.decodeObject(forKey: Key.state) as? String
    number = coder.decodeObject(forKey: Key.number) as? Int
    created_at = coder.decodeObject(forKey: Key.created_at) as? String
    updated_at = coder.decodeObject(forKey: Key.updated_at) as? String
    commentsUrl = coder.decodeObject(forKey: Key.commentsUrl) as? String

  }
  
}

extension FBIssue {
  class func getAllIssues(completionHandler: @escaping ([FBIssue]?, NSError?) -> Void) {
    let url = WebCallPath.getAllFirebaseIsuues
    _ = WebCallsHelper.callWebService(withUrlStr: url, httpMethod: WebCallType.get, queryParams: nil, bodyParams: nil) { (data, error) in
      if let object = data {
        if let array = object[WebCallPredefinedKeys.kData] as? [[String:Any]] {
          let movies = array.map { (object) -> FBIssue in
            return FBIssue(fromDictionary: object)
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



/*
{
    "url": "https://api.github.com/repos/firebase/firebase-ios-sdk/issues/7316",
    "repository_url": "https://api.github.com/repos/firebase/firebase-ios-sdk",
    "labels_url": "https://api.github.com/repos/firebase/firebase-ios-sdk/issues/7316/labels{/name}",
    "comments_url": "https://api.github.com/repos/firebase/firebase-ios-sdk/issues/7316/comments",
    "events_url": "https://api.github.com/repos/firebase/firebase-ios-sdk/issues/7316/events",
    "html_url": "https://github.com/firebase/firebase-ios-sdk/issues/7316",
    "id": 787393084,
    "node_id": "MDU6SXNzdWU3ODczOTMwODQ=",
    "number": 7316,
    "title": "Not documented \"original_price\" property of \"in_app_purchase\" event",
    "user": {
      "login": "GZaccaroni",
      "id": 17646575,
      "node_id": "MDQ6VXNlcjE3NjQ2NTc1",
      "avatar_url": "https://avatars3.githubusercontent.com/u/17646575?v=4",
      "gravatar_id": "",
      "url": "https://api.github.com/users/GZaccaroni",
      "html_url": "https://github.com/GZaccaroni",
      "followers_url": "https://api.github.com/users/GZaccaroni/followers",
      "following_url": "https://api.github.com/users/GZaccaroni/following{/other_user}",
      "gists_url": "https://api.github.com/users/GZaccaroni/gists{/gist_id}",
      "starred_url": "https://api.github.com/users/GZaccaroni/starred{/owner}{/repo}",
      "subscriptions_url": "https://api.github.com/users/GZaccaroni/subscriptions",
      "organizations_url": "https://api.github.com/users/GZaccaroni/orgs",
      "repos_url": "https://api.github.com/users/GZaccaroni/repos",
      "events_url": "https://api.github.com/users/GZaccaroni/events{/privacy}",
      "received_events_url": "https://api.github.com/users/GZaccaroni/received_events",
      "type": "User",
      "site_admin": false
    },
    "labels": [
      {
        "id": 612308725,
        "node_id": "MDU6TGFiZWw2MTIzMDg3MjU=",
        "url": "https://api.github.com/repos/firebase/firebase-ios-sdk/labels/needs-triage",
        "name": "needs-triage",
        "color": "b60205",
        "default": false,
        "description": ""
      }
    ],
    "state": "open",
    "locked": false,
    "assignee": null,
    "assignees": [

    ],
    "milestone": null,
    "comments": 1,
    "created_at": "2021-01-16T08:44:47Z",
    "updated_at": "2021-01-16T08:45:55Z",
    "closed_at": null,
    "author_association": "NONE",
    "active_lock_reason": null,
    "body": "<!-- DO NOT DELETE\r\nvalidate_template=true\r\ntemplate_path=.github/ISSUE_TEMPLATE/bug_report.md\r\n-->\r\n### [REQUIRED] Step 1: Describe your environment\r\n\r\n  * Xcode version: 12.3\r\n  * Firebase SDK version: 7.4.0\r\n  * Installation method: `CocoaPods`\r\n  * Firebase Component: Analytics\r\n\r\n### [REQUIRED] Step 2: Describe the problem\r\n\r\n#### Steps to reproduce:\r\n\r\nFirebase Analytics is tracking insanely high values of `original_price` `in_app_purchase ` event property.\r\nThis property is not documented anywhere.\r\n<img width=\"513\" alt=\"Screenshot 2021-01-16 at 09 39 58\" src=\"https://user-images.githubusercontent.com/17646575/104807446-74924a80-57df-11eb-8a9b-244ee4959f3c.png\">\r\n",
    "performed_via_github_app": null
  },
 */
