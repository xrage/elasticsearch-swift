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
    
    func printer(callback : @escaping (Any) -> ()){
        let params = ["size": 100, "_source": ["_id"]] as [String : Any]
        transport.performPost(path: "/buy/_search/", params: params as Dictionary<String, AnyObject>?){
            resp in
                callback(resp)
        }
    }
    
}
