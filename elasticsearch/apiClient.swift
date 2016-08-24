
//
//  connection.swift
//  elasticsearch
//
//  Created by Dharmendra Verma on 19/08/16.
//  Copyright © 2016 Dharmendra Verma. All rights reserved.
//

import Foundation


class ApiClient: NSObject{

    
    internal func get(request: URLRequest, responseCallback: @escaping (Int, AnyObject?) -> ()) {
        execTask(request: request, taskCallback: { (status, resp)  -> Void in
            responseCallback(status, resp)
        })
    }
    
    internal func patch(request: URLRequest, responseCallback: @escaping (Int, AnyObject?) -> ()) {
        execTask(request: request, taskCallback: { (status, resp)  -> Void in
            responseCallback(status, resp)
        })
    }
    
    internal func delete(request: URLRequest, responseCallback: @escaping (Int, AnyObject?) -> ()) {
        execTask(request: request, taskCallback: { (status, resp)  -> Void in
            responseCallback(status, resp)
        })
    }
    
    internal func put(request: URLRequest, responseCallback: @escaping (Int, AnyObject?) -> ()) {
        execTask(request: request, taskCallback: { (status, resp)  -> Void in
            responseCallback(status, resp)
        })
    }
    
    internal func head(request: URLRequest, responseCallback: @escaping (Int, AnyObject?) -> ()) {
        execTask(request: request, taskCallback: { (status, resp)  -> Void in
            responseCallback(status, resp)
        })
    }
    
    internal func post(request: URLRequest, responseCallback: @escaping (Int, AnyObject?) -> ()) {
        execTask(request: request) { (status, resp) in
            responseCallback(status, resp)
        }
    }
    
    private func execTask(request: URLRequest, taskCallback: @escaping (Int,
        AnyObject?) -> ()) {
        let session = URLSession.shared
        session.dataTask(with: request) {(data, response, error) -> Void in
            let response = response as? HTTPURLResponse
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                taskCallback((response?.statusCode)!, json as AnyObject?)
            }
            else{
                let status = response == nil ? 500 : response?.statusCode
                taskCallback(status!, error?.localizedDescription as AnyObject?)
            }
        }.resume()
    }
    
    internal func clientURLRequest( connection: HttpConnection, method: RequestMethod.RawValue,  body: Dictionary<String, Any>? = nil) -> URLRequest {
        var request = URLRequest(url: connection.uri)
        request.httpMethod = method
        request.timeoutInterval = 10
        do {
            if body != nil && !(body?.isEmpty)!{
                let jsonData = try JSONSerialization.data(withJSONObject: (body! as [String : Any]), options: .prettyPrinted)
                request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                request.httpBody = jsonData
            }
            
        } catch let error as NSError {
            print(error)
        }
        return request
    }
}

