//
//  httpconnection.swift
//  elasticsearch
//
//  Created by Dharmendra Verma on 07/08/16.
//  Copyright © 2016 Dharmendra Verma. All rights reserved.
//

import Foundation

class HttpConnection: NSObject{
 
    var uri: URL!
    var host: String!
    var port: String!
    var ssl: Bool = false
    var scheme:String! = "http"
    var username: String?
    var password: String?
    var path: String?
    
    required init(url: String!) {
        
        var normalizedHost: String = url
        if !normalizedHost.hasPrefix("http"){
            normalizedHost = "http://\(normalizedHost)"
        }
        self.uri = URL(string: "\(normalizedHost)")
        let d: [String: String]? = self.uri?.fragments
        self.host = d?["host"]
        self.port = d?["port"]
        self.scheme = d?["scheme"]
        self.ssl = self.scheme == "https" ? true : false
        self.username = d?["username"]
        self.password = d?["password"]
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let rhs = object as? HttpConnection else {
            return false
        }
        let lhs = self
        // For equality, check all 3 vars
        return lhs.host == rhs.host && lhs.port == rhs.port && lhs.scheme == rhs.scheme && lhs.ssl == rhs.ssl
    }
    
    
    func perform(method: RequestMethod.Type){
        
    }
}
