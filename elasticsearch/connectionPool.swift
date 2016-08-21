//
//  connectionpool.swift
//  elasticsearch
//
//  Created by Dharmendra Verma on 17/08/16.
//  Copyright © 2016 Dharmendra Verma. All rights reserved.
//

import Foundation


enum TransportError: Error {
    case improperlyConfigured
    case liveConnectionNotFoundError
}

enum SelectorClass{
    case randomSelector
    case roundRobinSelector
}


protocol ConnectionSelector{
    
    var connections:[HttpConnection] { get set }
    func select() -> HttpConnection
}


class RandomSelector: ConnectionSelector{
    internal var connections: [HttpConnection] = []

    func select() -> HttpConnection {
        return self.connections.randomItem()
    }
    
}

class RoundRobinSelector: ConnectionSelector{
    
    internal var connections: [HttpConnection] = []
    var rr: Int = -1
    
    func select() -> HttpConnection {
        self.rr += 1
        self.rr %= self.connections.count
        return self.connections[self.rr]
    }
    
}


class ConnectionPool{
    
    var connections: [HttpConnection] = []
    var dead_timeout:Int
    var dead_connection_pool: [URL: [String: AnyObject]]
    var selectorClass:SelectorClass
    
    required init(dead_timeout:Int = 10, selectorClass:SelectorClass) throws {
        self.dead_connection_pool = [:]
        self.dead_timeout = dead_timeout
        self.selectorClass = selectorClass
    }
    
    func mark_dead(_ connection: HttpConnection){
        remove_connection(connection)
        //Improve logic here for increasing deadcount based on increasing number of failures
        if self.dead_connection_pool[connection.uri] == nil{
            self.dead_connection_pool[connection.uri] = ["timeout" : self.dead_timeout as AnyObject, "dead_count": 1 as AnyObject, "connection": connection]
        }else{
            let dead_count = self.dead_connection_pool[connection.uri]!["dead_count"] as! Int
            self.dead_connection_pool[connection.uri]!["dead_count"] = (dead_count + 1) as AnyObject
        }
    }
    
    func mark_live(_ connection: HttpConnection){
        self.add_connections(connection: connection)
        if self.dead_connection_pool[connection.uri] != nil{
            self.dead_connection_pool.removeValue(forKey: connection.uri)
        }
    }
    
    func resurrect(){
        let threshold_minutes: Int = Int(NSDate().timeIntervalSince1970) + self.dead_timeout
        for uri in self.dead_connection_pool.keys{
            if (self.dead_connection_pool[uri]!["timeout"] as! Int) < threshold_minutes || (self.connections.count == 0){
                self.mark_live(self.dead_connection_pool[uri]!["connection"] as! HttpConnection)
            }
        }
    }
    
    func get_connection() throws -> HttpConnection{
        self.resurrect()
        let selector: ConnectionSelector
        guard self.connections.count > 0 else {
            throw TransportError.liveConnectionNotFoundError
        }
        switch selectorClass{

        case .randomSelector:
            selector = RandomSelector()
            
        case .roundRobinSelector:
            selector = RoundRobinSelector()
        }
        selector.connections = self.connections
        return selector.select()
        
    }
    
    private func add_connections(connection: HttpConnection) -> Void{
        if self.connections.index(of: connection) == nil{
            self.connections.append(connection)
        }
    }

    private func remove_connection(_ connection: HttpConnection) -> Void{
        self.connections.remove(at: self.connections.index(of: connection)!)
    }
}
