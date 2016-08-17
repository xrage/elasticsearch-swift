//
//  httpconnection.swift
//  elasticsearch
//
//  Created by Dharmendra Verma on 07/08/16.
//  Copyright © 2016 Dharmendra Verma. All rights reserved.
//

import Foundation

class HttpConnection: NSObject{
 
    var uri: String!
    
    override func isEqual(_ object: AnyObject?) -> Bool {
        guard let rhs = object as? HttpConnection else {
            return false
        }
        let lhs = self
        return lhs.uri == rhs.uri
    }
    
}
