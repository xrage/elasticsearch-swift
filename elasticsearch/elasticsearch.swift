//
//  elasticsearch.swift
//  elasticsearch-swift
//
//  Created by Dharmendra Verma on 07/08/16.
//


import Foundation

class Elasticsearch: Indices{

    var getAsPost: Bool = false
    
    required override init(hosts: Array<String>, index: String, type: String?) {
        super.init(hosts: hosts, index: index, type: type)
        self.transport.toggleGet = self.getAsPost
    }
    
    func search(index: String, type: String, params: [String: Any]?, body: [String: Any]?, resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(index: index, type: type, suffix: "_search")
        self.transport.performPost(path: path, params: params, body: body){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
}
