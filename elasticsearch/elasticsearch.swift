//
//  elasticsearch.swift
//  elasticsearch-swift
//
//  Created by Dharmendra Verma on 07/08/16.
//


import Foundation

class Elasticsearch{
    
    var hosts:Array<String> = []
    let transport: Transport = Transport()
    
    
    init (hosts:Array<String>){
        transport.hosts = hosts
        transport.setConnections()
    }
    
    func printer(){
        let params = ["size": 100, "_source": ["_id"]] as [String : Any]
        let data = transport.performPost(path: "/buy/_search/", params: params as Dictionary<String, AnyObject>?)
        print(data)
    }
    
}
