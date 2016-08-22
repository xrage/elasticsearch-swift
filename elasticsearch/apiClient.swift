
//
//  connection.swift
//  elasticsearch
//
//  Created by Dharmendra Verma on 19/08/16.
//  Copyright © 2016 Dharmendra Verma. All rights reserved.
//

import Foundation


class ApiClient: NSObject{

    
    internal func get(request: URLRequest, responseCallback: @escaping (Bool, AnyObject?) -> ()) {
        execTask(request: request, taskCallback: { (status, resp)  -> Void in
            responseCallback(status, resp)
        })
    }
    
    internal func patch(request: URLRequest, responseCallback: @escaping (Bool, AnyObject?) -> ()) {
        execTask(request: request, taskCallback: { (status, resp)  -> Void in
            responseCallback(status, resp)
        })
    }
    
    internal func delete(request: URLRequest, responseCallback: @escaping (Bool, AnyObject?) -> ()) {
        execTask(request: request, taskCallback: { (status, resp)  -> Void in
            responseCallback(status, resp)
        })
    }
    
    internal func put(request: URLRequest, responseCallback: @escaping (Bool, AnyObject?) -> ()) {
        execTask(request: request, taskCallback: { (status, resp)  -> Void in
            responseCallback(status, resp)
        })
    }
    
    
    internal func post(request: URLRequest, responseCallback: @escaping (Bool, AnyObject?) -> ()) {
        execTask(request: request) { (status, resp) in
            responseCallback(status, resp)
        }
    }
    
    private func execTask(request: URLRequest, taskCallback: @escaping (Bool,
        AnyObject?) -> ()) {
        
        let session = URLSession.shared
        session.dataTask(with: request) {(data, response, error) -> Void in
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode {
                    taskCallback(true, json as AnyObject?)
                } else {
                    taskCallback(false, json as AnyObject?)
                }
            }
        }.resume()
    }
    
    internal func clientURLRequest( url: URL, path: String, method: RequestMethod.RawValue,  params: Dictionary<String, Any>? = nil) -> URLRequest {
        var url = url
        url.appendPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.timeoutInterval = 10
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: (params! as [String : Any]), options: .prettyPrinted)
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
        } catch let error as NSError {
            print(error)
        }
        return request
    }
}

