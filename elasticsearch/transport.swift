//
//  transport.swift
//  elasticsearch-swift
//
//  Created by Dharmendra Verma on 07/08/16.
//
//


import Foundation


enum RequestMethod: String{
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case HEAD = "HEAD"
    case PATCH = "PATCH"
    case DELETE = "DELETE"
}

struct Transport {
    var connectionPoolClass:ConnectionPool.Type! = ConnectionPool.self
    var connectionClass:HttpConnection.Type! = HttpConnection.self
    var selectorClass:SelectorClass = SelectorClass.roundRobinSelector
    var connectionPool:ConnectionPool?
    var hosts: [String] = []
    var deadTimeout: Int = 5
    var apiClient = ApiClient()
    var toggleGet: Bool = false

    
    mutating func setConnections() {
        do {
            self.connectionPool = try self.connectionPoolClass.init(deadTimeout: self.deadTimeout, selectorClass: self.selectorClass)
        } catch TransportError.improperlyConfigured{
            print("improperly configured hosts")
        } catch{
            print("Some Unknown Error occurred")
        }
        if self.connectionPool == nil{
            NSException(name:NSExceptionName(rawValue: "connectionPool"), reason:"Error occurred", userInfo:nil).raise()
        }
        
        for host in self.hosts{
            addConnection(host: host)
        }
    }
    
    internal func addConnection(host: String) -> Void {
        let cc = connectionClass.init(url: host)
        self.connectionPool?.markLive(cc)
    }
    
    internal func markDeadConnection(connection: HttpConnection) -> Void {
        self.connectionPool?.markDead(connection)
    }
    
    internal func getConnection() -> HttpConnection{
        let con: HttpConnection?
        do { try con = self.connectionPool?.get_connection()}
        catch {
            con = nil
            NSException(name:NSExceptionName(rawValue: "ConnectionError"), reason:"No Live Connection Found", userInfo:nil).raise()}
        return con!
    }
    
    internal func performGet(path: String, params: Dictionary<String, Any>? = nil, afterGet: @escaping (Int, Any?) -> ()){
        let method:RequestMethod.RawValue
        if self.toggleGet{
            method = RequestMethod.POST.rawValue
        }else{
            method = RequestMethod.GET.rawValue
        }
        processRequest(method: method, path: path,  params: params, callback: {status, resp in
            afterGet(status, resp)
        })
    }
    
    internal func performPost(path: String, params: Dictionary<String, Any>? = nil, afterPost: @escaping (Int, Any?) -> ()){
        processRequest(method: RequestMethod.POST.rawValue, path: path,  params: params, callback: {status, resp in
            afterPost(status, resp)
        })
    }
    
    internal func performPatch(path: String, params: Dictionary<String, Any>? = nil, afterPatch: @escaping (Int, Any?) -> ()){
        processRequest(method: RequestMethod.PATCH.rawValue, path: path,  params: params, callback: {status, resp in
            afterPatch(status, resp)
        })
    }
    
    internal func performHead(path: String, params: Dictionary<String, Any>? = nil, afterHead: @escaping (Int, Any?) -> ()){
        processRequest(method: RequestMethod.HEAD.rawValue, path: path,  params: params, callback: {status, resp in
            afterHead(status, resp)
        })
    }
    
    internal func performPut(path: String, params: Dictionary<String, Any>? = nil, afterPut: @escaping (Int, Any?) -> ()){
        processRequest(method: RequestMethod.PUT.rawValue, path: path,  params: params, callback: {status, resp in
            afterPut(status, resp)
        })
    }
    internal func performDelete(path: String, params: Dictionary<String, Any>? = nil, afterDelete: @escaping (Int, Any?) -> ()){
        processRequest(method: RequestMethod.DELETE.rawValue, path: path,  params: params, callback: {status, resp in
            afterDelete(status, resp)
        })
    }
    
    private func processRequest(method: RequestMethod.RawValue, path: String, params: Dictionary<String, Any>?, callback: @escaping (Int, Any) -> ()) -> Void{
        let connection = self.getConnection()
        connection.path = path
        self.apiClient.post(request: self.apiClient.clientURLRequest(connection: connection, method:method, params: params), responseCallback: {status, resp in
            callback(status, resp)
        })
    }

}
