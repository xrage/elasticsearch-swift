//
//  utility.swift
//  elasticsearch-swift
//
//  Created by Dharmendra Verma on 07/08/16.
//
//

import Foundation


internal func extractURLComponents(_ url: URL) -> Dictionary<String, String>{
    let port:NSNumber = (url as NSURL).port == nil ? 80 : (url as NSURL).port!
    let components:Dictionary<String, String> =  ["host":url.host!, "port": "\(port)", "scheme": url.scheme!]
    return components
}

internal func get_host_info(_ node_info: Dictionary<String, Dictionary<String, AnyObject>>, host:String) -> String?{
    
    let attrs = (node_info["attributes"] == nil) ? Dictionary() : node_info["attributes"]!
    let data = (attrs["data"] == nil) ? true : attrs["data"] as! Bool
    let client = (attrs["client"] == nil) ? false : attrs["client"] as! Bool
    let master = (attrs["master"] == nil) ? true : attrs["master"] as! Bool
    
    if data && client && master{
        return nil
    }
    return host
}
