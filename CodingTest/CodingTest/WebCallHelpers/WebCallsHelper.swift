
//
//  WebCallsHelper.swift
//  CodingTest
//
//  Created by Aklesh on 17/01/21.
//

import UIKit
import SystemConfiguration
let baseUrl = "https://api.github.com/repos/firebase/firebase-ios-sdk"




public struct WebCallPath {
    static let getAllFirebaseIsuues = "/issues"
}

public struct WebCallType {
    static let get = "GET"
    static let put = "PUT"
    static let post = "POST"
    static let delete = "DELETE"
}

public struct WebCallPredefinedKeys {
    static let kStatus = "Status"
    static let kSuccessMsg = "success"
    static let kData = "Data"
    static let kError = "Error"
    static let kErrorMsg = "message"
    static let kErrorCode = "Code"
}


class WebCallsHelper: NSObject {
  
    /**
     Method to create mutable URL Request object with our pre required headers set
     - parameter url : url for creating mutable url request
     - returns : mutable url request object, on which you can set other required parameters and then call webservice
     */
  class func getMutableRequestObj(withUrlStr urlStr:String, httpMethod:String, queryParamsDict:[String:Any]?, bodyParamsDict:[String:Any]?) -> NSMutableURLRequest? {
        let completeUrlPath = baseUrl + urlStr
        guard let url = WebCallsHelper.getURLWith(urlStr: completeUrlPath, queryParamsDict: queryParamsDict) else{
            return nil
        }
        let request = NSMutableURLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField:"Content-Type")
        request.addValue("application/json", forHTTPHeaderField:"Accept")
        request.addValue("", forHTTPHeaderField:"description")

        request.httpMethod = httpMethod
        if let body = bodyParamsDict {
          do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions())
             } catch let error {
                print(error.localizedDescription)
            }
        }
        return request
    }
    
    
    class func getURLWith(urlStr:String, queryParamsDict:[String:Any]?) -> URL? {
        let newURL = urlStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        guard var components = URLComponents(string: newURL ?? urlStr) else { return nil }
        if queryParamsDict != nil{
            components.queryItems = queryParamsDict!.map({ (key, value) -> URLQueryItem in
              return URLQueryItem(name: key, value: value as? String)
            })
        }
        
        return components.url
    }
    
    
    /**
     Webservice to call get urls and returning json response in dictionary format
     - parameter urlRequestObj : URLRequest to make call
     - returns : it returns URLSessionDataTask object, which can be used to cancel or pause this operation. Also, this method returns data in form of completionHandler, with jsonDictionary and error as response
     */
    class func callWebService(withUrlStr urlStr:String, httpMethod:String, queryParams:[String:Any]?, bodyParams:[String:Any]?, withCompletionHandler completionHandler:@escaping ((_ responseDict:[String:Any]?,_ error:NSError?)->Void)) -> URLSessionDataTask? {
        if WebCallsHelper.isConnectedToNetwork() == false{
          completionHandler(nil, WebCallsHelper.getNoInternetError() )
            return nil
        }
      
      guard let urlRequestObj = WebCallsHelper.getMutableRequestObj(withUrlStr: urlStr, httpMethod: httpMethod, queryParamsDict: queryParams, bodyParamsDict: bodyParams) else { completionHandler(nil, WebCallsHelper.getNoInternetError() )
          return nil }
        
        let sessionTask = URLSession.shared.dataTask(with: urlRequestObj as URLRequest) { (data, response, error) in
          
            DispatchQueue.main.async {
                var jsonDict:[String:Any]?
                if error != nil{
                  //print("error response is \(error! )")
                  completionHandler(nil,error as NSError?)
                    return
                }

              let httpResponse = response as! HTTPURLResponse
             print("httpResponse is \(httpResponse )")

              if httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 {
                if data != nil{
                    do {
                        let jsonObject = try JSONSerialization.jsonObject(with: data!, options: [])
                      print("jsonObject is \(jsonObject )")

                        if let newDict = jsonObject as? [[String:Any]]{
                          jsonDict = [WebCallPredefinedKeys.kData:newDict]
                         // print("server response in jsonDict is \(jsonDict!)")
                          completionHandler(jsonDict,nil)
                        }else if let newDict = jsonObject as? [String:Any]{
                          jsonDict = newDict
                         // print("server response in jsonDict is \(jsonDict!)")
                          completionHandler(jsonDict,nil)
                        }else{
                          completionHandler(nil, WebCallsHelper.getLocalError())
                            return
                        }
                    } catch {
                        completionHandler(nil, WebCallsHelper.getLocalError())
                        return
                    }
                }
                else{
                  completionHandler(nil, WebCallsHelper.getLocalError())
                  return
                }
              } else{
                completionHandler(nil, WebCallsHelper.getLocalError())
                return
              }
            }
            }
        sessionTask.resume()
        return sessionTask
    }
    
    
    /**
     method to check if internet connection is available or nmot
     - returns : returnst bool indicating network status
     */
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
        
    }
  
 class func getNoInternetError() -> NSError {
   let userInfo: [AnyHashable : Any] =
        [
            NSLocalizedDescriptionKey :  NSLocalizedString("NotReachable", value: "No Internet Connection", comment: "") ,
            NSLocalizedFailureReasonErrorKey : NSLocalizedString("NotReachable", value: "No Internet Connection", comment: "")
    ]
    let err = NSError(domain: "InternetConnection", code: 12029, userInfo: userInfo as? [String : Any])
    return err
  }
  
 class func getLocalError() -> NSError {
   let userInfo: [AnyHashable : Any] =
        [
            NSLocalizedDescriptionKey :  NSLocalizedString("localError", value: "Internal Server Error", comment: "") ,
            NSLocalizedFailureReasonErrorKey : NSLocalizedString("localError", value: "Internal Server Error", comment: "")
    ]
    let err = NSError(domain: "Dummy", code: 12004, userInfo: userInfo as? [String : Any])
    return err
  }
  
 class func callWebServiceWithImageUpload(image: UIImage, uploadUrl: String,  httpMethod: String, param: [String:Any]?, withCompletionHandler completionHandler:@escaping ((_ success:Bool?,_ error:NSError?)->Void)) {
    
    guard let urlRequestObj = WebCallsHelper.getMutableRequestObj(withUrlStr: uploadUrl, httpMethod: httpMethod, queryParamsDict: nil, bodyParamsDict: nil) else { completionHandler(nil, WebCallsHelper.getNoInternetError() )
        return }



          let boundary = WebCallsHelper.generateBoundaryString()

          urlRequestObj.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

          let imageData = image.jpegData(compressionQuality: 1)

          if(imageData==nil)  { return; }

          urlRequestObj.httpBody = WebCallsHelper.createBodyWithParameters(parameters: param, filePathKey: "profile_pic", imageDataKey: imageData!, boundary: boundary) as Data

          //myActivityIndicator.startAnimating();

       // print("request object is \(urlRequestObj)")
        let sessionTask = URLSession.shared.dataTask(with: urlRequestObj as URLRequest) { (data, response, error) in
     // print(" response is \(response  ?? nil)")

        DispatchQueue.main.async {
            var jsonDict:[String:Any]?
            if error != nil{
             // print("error response is \(error! )")
              completionHandler(nil,error as NSError?)
                return
            }

          let httpResponse = response as! HTTPURLResponse
         // print("error response is \(httpResponse )")

          if httpResponse.statusCode == 200 {
            if data != nil{
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data!, options: [])
                    if let newDict = jsonObject as? [[String:Any]]{
                      jsonDict = [WebCallPredefinedKeys.kData:newDict]
                     // print("server response in jsonDict is \(jsonDict!)")
                      completionHandler(true,nil)
                    }else if let newDict = jsonObject as? [String:Any]{
                      jsonDict = newDict
                      //print("server response in jsonDict is \(jsonDict!)")
                      completionHandler(true,nil)
                    }else{
                      completionHandler(nil, WebCallsHelper.getLocalError())
                        return
                    }
                } catch {
                    completionHandler(nil, WebCallsHelper.getLocalError())
                    return
                }
            }
            else{
              completionHandler(nil, WebCallsHelper.getLocalError())
              return
            }
          }
          else{
            completionHandler(nil, WebCallsHelper.getLocalError())
            return
          }
        }
        }
    sessionTask.resume()


  }


    class func createBodyWithParameters(parameters: [String: Any]?, filePathKey: String?, imageDataKey: Data, boundary: String) -> NSData {
          let body = NSMutableData();

          if parameters != nil {
              for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
              }
          }

          let filename = "user-profile.jpg"

          let mimetype = "image/jpg"

        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")

        body.appendString(string: "--\(boundary)--\r\n")

          return body
      }

     class func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
      }

  }

extension NSMutableData {

    func appendString(string: String) {
      let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
      append(data!)
    }
}



                  

