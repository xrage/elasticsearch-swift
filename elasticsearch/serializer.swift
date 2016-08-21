//
//  serializer.swift
//  elasticsearch
//
//  Created by Dharmendra Verma on 07/08/16.
//  Copyright © 2016 Dharmendra Verma. All rights reserved.
//

import Foundation

struct JSONSerializer {

    static func jsonObject(with data: Data, callback: (AnyObject?, NSError?) -> ()) -> Void{
        do {
            let d: AnyObject = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
            callback(d, nil)
        } catch let error as NSError {
            callback(nil, error)
        }
    }
    
    static func jsonData(with data: AnyObject, callback: (Data?, NSError?) -> ()) -> Void{
        do {
            let d: Data = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            callback(d, nil)
        } catch let error as NSError {
            callback(nil, error)
        }
    }
    
}
