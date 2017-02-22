//
//  ServerManager.swift
//  GithubAPITest
//
//  Created by Danilo S Marshall on 22/02/17.
//  Copyright © 2017 danilomarshall. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ServerManager {
    private var serverBaseURL: String? = nil
    
    init() {
        self.serverBaseURL = Constants.Server.BaseURL
    }
    
    init(baseURL: String) throws {
        var isValid: Bool = false
        if let url = URL(string: baseURL) {
            // check if application can open the URL instance
            isValid = UIApplication.shared.canOpenURL(url)
        }
        
        if isValid {
            self.serverBaseURL = baseURL
        } else {
            throw GitTestError.InvalidConfigurations
        }
    }
    
    // MARK: - Basic requests
    
    func getData(url: String, params: Parameters!, completionHandler: @escaping (JSON?, NSError?) -> ()) {
        
        // DEBUG to test any get request
        //let request = Alamofire.request("http://httpbin.org/get", method: .get, parameters: nil, encoding: JSONEncoding.default)
        
        var getParams = ""
        
        if (params != nil) {
            // Convert parameters to string
            let jsonParams = JSON(params)
            //print(jsonParams)
            
            getParams = "?"
            
            for item in jsonParams {
                var itemID = item.0
                let itemValue = item.1
                
                var nums = ""
                
                if itemValue.type == .array {
                    let array : Array = itemValue.array!
                    
                    nums = "\(array[0])"
                    for num in array {
                        if num == array.first {
                            
                        }
                        else {
                            nums = "\(nums),\(num)"
                        }
                    }
                }
                else {
                    nums = itemValue.stringValue
                }
                
                if item == jsonParams.first! {
                    
                }
                else {
                    itemID = "&\(itemID)"
                }
                
                getParams = "\(getParams)\(itemID)=\(nums)"
            }
        }
        
        
        let urlString = "\(serverBaseURL)\(url)\(getParams)"
        
        // DEBUG to test url sent
        print("url: \(urlString)")
        
        let request = Alamofire.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default)
        request.validate()
        
        
        request.responseJSON { response in
            // do whatever you want here
            //print(response)
            
            switch response.result {
            case .failure(let error):
                print(error)
                
                
                // Errors are the same returned from NSURLError - URL Loading System Error Codes
                let convertedError : NSError = error as NSError
                
                print("Failure")
                
                if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
                    print(responseString)
                }
                //WebError.sharedErrorService.displayAlert(error: convertedError)
                
                completionHandler(nil, convertedError)
            case .success(let responseObject):
                //print("Success")
                //DEBUG - to test response received from server
                //print(responseObject)
                
                let jsonObj = JSON(responseObject)
                
                completionHandler(jsonObj, nil)
            }
        }
        
    }
    
    func postData(url: String, params: Parameters, completionHandler: @escaping (JSON?, NSError?) -> ()) {
        let urlString = "\(serverBaseURL)\(url)"
        
        // DEBUG - to test url sent
        //print("url: \(urlString)")
        //print("params: \(params)")
        
        let request = Alamofire.request(urlString, method: .post, parameters: params, encoding: URLEncoding.httpBody)
        request.validate()
        
        request.responseJSON { response in
            // do whatever you want here
            //print(response)
            
            switch response.result {
            case .failure(let error):
                print(error)
                
                // Errors are the same returned from NSURLError - URL Loading System Error Codes
                let convertedError : NSError = error as NSError
                
                print("Failure")
                
                if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
                    print(responseString)
                }
                //WebError.sharedErrorService.displayAlert(error: convertedError)
                
                
                completionHandler(nil, convertedError)
            case .success(let responseObject):
                //print("Success")
                //DEBUG - to test response received from server
                //print(responseObject)
                
                let jsonObj = JSON(responseObject)
                
                completionHandler(jsonObj, nil)
            }
        }
        
    }

}
