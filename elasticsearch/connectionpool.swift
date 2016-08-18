//
//  connectionpool.swift
//  elasticsearch
//
//  Created by Dharmendra Verma on 17/08/16.
//  Copyright © 2016 Dharmendra Verma. All rights reserved.
//

import Foundation


enum TransportError: ErrorProtocol {
    case ImproperlyConfigured
    case LiveConnectionNotFoundError
}

enum SelectorClass{
    case RandomSelector
    case RoundRobinSelector
}


protocol ConnectionSelector{
    
    var connections:[HttpConnection] { get set }
    
    init(connections: [HttpConnection])
    func select() -> HttpConnection
}

extension ConnectionSelector{
    
    init(connections: [HttpConnection]) {
        self.init(connections: connections)
        self.connections = connections
    }
}


class RandomSelector: ConnectionSelector{
    
    var connections: [HttpConnection] = []
    
    func select() -> HttpConnection {
        return self.connections.randomItem()
    }
    
}

class RoundRobinSelector: ConnectionSelector{
    
    var connections: [HttpConnection] = []
    var rr: Int = -1
    
    func select() -> HttpConnection {
        self.rr += 1
        self.rr %= self.connections.count
        return self.connections[self.rr]
    }
    
}


class ConnectionPool{
    
    var connections: [HttpConnection]
    var dead_timeout:Int
    var dead_connection_pool: [String: [String: AnyObject]]
    var selectorClass:SelectorClass
    
    init(connections: [HttpConnection], dead_timeout:Int = 10, selectorClass:SelectorClass) throws {
        guard connections.count > 0 else {
            throw TransportError.ImproperlyConfigured
        }
        self.dead_connection_pool = [:]
        self.dead_timeout = dead_timeout
        self.connections = connections
        self.selectorClass = selectorClass
    }
    
    func mark_dead(connection: HttpConnection){
        remove_connection(connection: connection)
        //Improve logic here for increasing deadcount based on increasing number of failures
        if self.dead_connection_pool[connection.uri] == nil{
            self.dead_connection_pool[connection.uri] = ["timeout" : self.dead_timeout, "dead_count": 1, "connection": connection]
        }else{
            let dead_count = self.dead_connection_pool[connection.uri]!["dead_count"] as! Int
            self.dead_connection_pool[connection.uri]!["dead_count"] = dead_count + 1
        }
    }
    
    func mark_live(connection: HttpConnection){
        self.add_connections(connection: connection)
        if self.dead_connection_pool[connection.uri] != nil{
            self.dead_connection_pool.removeValue(forKey: connection.uri)
        }
    }
    
    func resurrect(){
        let threshold_minutes: Int = NSDateComponents().minute + self.dead_timeout
        for uri in self.dead_connection_pool.keys{
            if (self.dead_connection_pool[uri]!["timeout"] as! Int) < threshold_minutes || (self.connections.count == 0){
                self.mark_live(connection: self.dead_connection_pool[uri]!["connection"] as! HttpConnection)
            }
        }
    }
    
    func get_connection() throws -> HttpConnection{
        self.resurrect()
        guard self.connections.count > 0 else {
            throw TransportError.LiveConnectionNotFoundError
        }
        switch selectorClass{
        case .RandomSelector:
            return RandomSelector(connections: self.connections).select()
        case .RoundRobinSelector:
            return RoundRobinSelector(connections: self.connections).select()
        }
        
    }
    
    private func add_connections(connection: HttpConnection) -> Void{
        if self.connections.index(of: connection) == -1{
            self.connections.append(connection)
        }
    }
    
    private func remove_connection(connection: HttpConnection) -> Void{
        self.connections.remove(at: self.connections.index(of: connection)!)
    }
}
