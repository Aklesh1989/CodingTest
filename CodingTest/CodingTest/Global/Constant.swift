//
//  Constant.swift
//  Contact
//
//  Created by Aklesh Rathaur on 26/11/19.
//  Copyright © 2019 Aklesh Rathaur. All rights reserved.
//

import UIKit

// Colors

let APP_DELEGATE = UIApplication.shared.delegate as! AppDelegate

/*public func downloadImage(from imageUrl:String, completionHandler:@escaping ((_ image:UIImage?)->Void)) {
  let completeImageUrl = imageBaseUrl + imageUrl
  guard let url = URL(string: completeImageUrl) else {
    completionHandler(nil)
    return
  }
     getData(from: url) { data, response, error in
         guard let data = data, error == nil else { return }
        // print(response?.suggestedFilename ?? url.lastPathComponent)
         let image = UIImage(data: data)
         completionHandler(image)
     }
 }

public func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
    URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
}
*/

public struct SegueIdentifier {
    static let IssueDetail = "IssueDetail"
}




