//
//  transport.swift
//  elasticsearch-swift
//
//  Created by Dharmendra Verma on 07/08/16.
//
//


import Foundation

class TransportProtocol {
//    var connectionClass:HttpConnection
//    var connectionPoolClass:ConnectionPool
//    var serializer:JSONSerializer
//    var serializers: AnyObject?
//    var defaultMimetype:String
//    var maxRetries: Int
//    var retryOnStatus: Int
//    var retryOnTimeout: Bool
//    var sendGetBodyAs: String
//    var sniffOnStart: Bool
//    var snifferTimeout:Float?
//    var sniffTimeout: Float
//    var sniffOnConnectionPool:Bool
    var hosts: [String]
    
    init(hosts: [String]) {
        self.hosts = hosts
    }
    
    func add_connection(host: String) -> Void {
        self.hosts.append(host)
    }
        

}
