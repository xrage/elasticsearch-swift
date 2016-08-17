//
//  serializer.swift
//  elasticsearch
//
//  Created by Dharmendra Verma on 07/08/16.
//  Copyright © 2016 Dharmendra Verma. All rights reserved.
//

import Foundation

struct JSONSerializer {

    static func jsonObject(with data: Data) -> (AnyObject?, error:NSError?){
        do {
            let d: AnyObject = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.mutableContainers)
            return (d, nil)
        } catch let error as NSError {
            return (nil, error)
        }
    }
    
    static func jsonData(with data: AnyObject) -> (Data?, error:NSError?){
        do {
            let d: Data = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            return (d, nil)
        } catch let error as NSError {
            return (nil, error)
        }
    }
    
}
