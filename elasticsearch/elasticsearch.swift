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
    
    func search(query: [String: Any], resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(suffix: "_search", enableType: true)
        self.transport.performPost(path: path, params: query){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
}
