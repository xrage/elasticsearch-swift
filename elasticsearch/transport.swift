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
    case PATCH = "PATCH"
    case DELETE = "DELETE"
}

class Transport {
    var connectionPoolClass:ConnectionPool.Type! = ConnectionPool.self
    var connectionClass:HttpConnection.Type! = HttpConnection.self
    var selectorClass:SelectorClass = SelectorClass.roundRobinSelector
    var connectionPool:ConnectionPool?
    var hosts: [String] = []
    var deadTimeout: Int = 5
    var apiClient = ApiClient()

    
    func setConnections() {
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
    
    func addConnection(host: String) -> Void {
        let cc = connectionClass.init(url: host)
        self.connectionPool?.markLive(cc)
    }
    
    func markDeadConnection(connection: HttpConnection) -> Void {
        self.connectionPool?.markDead(connection)
    }
    
    func getConnection() -> HttpConnection{
        let con: HttpConnection?
        do { try con = self.connectionPool?.get_connection()}
        catch {
            con = nil
            NSException(name:NSExceptionName(rawValue: "ConnectionError"), reason:"No Live Connection Found", userInfo:nil).raise()}
        return con!
    }
    
    func performGet(path: String, params: Dictionary<String, AnyObject>?, afterGet: @escaping (Any?) -> ()){
        let connection = self.getConnection()
        connection.path = path
        processRequest(method: RequestMethod.GET.rawValue, connection: connection,  params: params, callback: {result, resp in
            afterGet(resp)
        })
    }
    
    func performPost(path: String, params: Dictionary<String, AnyObject>?, afterPost: @escaping (Any?) -> ()){
        let connection = self.getConnection()
        connection.path = path
        processRequest(method: RequestMethod.POST.rawValue, connection: connection,  params: params, callback: {result, resp in
            afterPost(resp)
        })
    }
    
    private func processRequest(method: RequestMethod.RawValue, connection: HttpConnection, params: Dictionary<String, AnyObject>?, callback: @escaping (Bool, Any) -> ()) -> Void{
        self.apiClient.post(request: self.apiClient.clientURLRequest(url: connection.uri, path: connection.path!, method:method, params: params), responseCallback: {result, resp in
            if result{
                callback(true, resp)
            }else{
                callback(false, resp)
            }
        })
    }

}
