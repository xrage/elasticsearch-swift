//
//  elasticsearch.swift
//  elasticsearch-swift
//
//  Created by Dharmendra Verma on 07/08/16.
//


import Foundation

class Elasticsearch{
    
    var hosts:Array<String> = []
    
    init (hosts:Array<String>){
        _ = TransportClass()
        self.hosts = hosts
        
    }
    
    func printer(){
        print(normalize_hosts(hosts: self.hosts))
    }
    
    
    private func normalize_hosts(hosts:Array<String>) -> [Dictionary<String, String>]{
        if hosts.count == 0{
            return []
        }
        var hosts_list: [Dictionary<String, String>] = []
        for host in hosts{
            let url = NSURL(string: host)
            let data = url?.fragments
            hosts_list.append(data!)
        }
        return hosts_list
    }
    
    
}
