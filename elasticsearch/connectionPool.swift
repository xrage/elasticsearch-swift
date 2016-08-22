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
    var deadTimeout:Int
    var deadConnectionPool: [URL: [String: AnyObject]]
    var selectorClass:SelectorClass
    
    required init(deadTimeout:Int = 10, selectorClass:SelectorClass) throws {
        self.deadConnectionPool = [:]
        self.deadTimeout = deadTimeout
        self.selectorClass = selectorClass
    }
    
    func markDead(_ connection: HttpConnection){
        removeConnection(connection)
        //Improve logic here for increasing deadcount based on increasing number of failures
        if self.deadConnectionPool[connection.uri] == nil{
            self.deadConnectionPool[connection.uri] = ["timeout" : self.deadTimeout as AnyObject, "dead_count": 1 as AnyObject, "connection": connection]
        }else{
            let dead_count = self.deadConnectionPool[connection.uri]!["dead_count"] as! Int
            self.deadConnectionPool[connection.uri]!["dead_count"] = (dead_count + 1) as AnyObject
        }
    }
    
    func markLive(_ connection: HttpConnection){
        self.addConnections(connection: connection)
        if self.deadConnectionPool[connection.uri] != nil{
            self.deadConnectionPool.removeValue(forKey: connection.uri)
        }
    }
    
    func resurrect(){
        let thresholdMinutes: Int = Int(NSDate().timeIntervalSince1970) + self.deadTimeout
        for uri in self.deadConnectionPool.keys{
            if (self.deadConnectionPool[uri]!["timeout"] as! Int) < thresholdMinutes || (self.connections.count == 0){
                self.markLive(self.deadConnectionPool[uri]!["connection"] as! HttpConnection)
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
    
    private func addConnections(connection: HttpConnection) -> Void{
        if self.connections.index(of: connection) == nil{
            self.connections.append(connection)
        }
    }

    private func removeConnection(_ connection: HttpConnection) -> Void{
        self.connections.remove(at: self.connections.index(of: connection)!)
    }
}
