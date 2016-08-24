//
//  Indices.swift
//  elasticsearch
//
//  Created by Dharmendra Verma on 23/08/16.
//  Copyright © 2016 Dharmendra Verma. All rights reserved.
//

import Foundation

internal class Indices{
   
    var hosts:Array<String> = []
    var transport: Transport = Transport()
    
    init (hosts:Array<String>, index:String, type:String?){
        self.transport.hosts = hosts
        self.transport.setConnections()
    }

    
    func refreshIndex(index: String, params: [String: Any]?, body: [String: Any]?, resultCallback: @escaping (Int, Any?) -> ()) {
        let filteredParams = params?.filterAllowedKeys(allowedParams: ["allow_no_indices", "expand_wildcards", "force", "ignore_unavailable"])
        let path = self.preparePath(index: index, suffix: "_refresh")
        transport.performGet(path: path, params: filteredParams, body: body){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    
    func flush(index: String, params: [String: Any]?, body: [String: Any]?, resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(index: index, suffix: "_flush")
        transport.performPost(path: path, params:params, body: body){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    func analyze(index: String, params: [String: Any]?, body: [String: Any]?, resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(index: index, suffix: "_analyze")
        transport.performGet(path: path, params:params, body: body){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    func createIndex(index: String, params: [String: Any]?, body: [String: Any]?, resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(index: index, suffix: "")
        transport.performPost(path: path, params:params, body: body){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    func getIndex(index: String, params: [String: Any]?, body: [String: Any]?, resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(index: index, suffix: "")
        transport.performGet(path: path, params:params, body: body){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    func openIndex(index: String, params: [String: Any]?, body: [String: Any]?, resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(index: index, suffix: "_open")
        transport.performPost(path: path, params:params, body: body){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    
    func closeIndex(index: String, params: [String: Any]?, body: [String: Any]?, resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(index: index, suffix: "_close")
        transport.performPost(path: path, params:params, body: body){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    func deleteIndex(index: String, params: [String: Any]?, body: [String: Any]?, resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(index: index, suffix: "")
        transport.performDelete(path: path, params:params, body: body){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    func exists(index: String, params: [String: Any]?, body: [String: Any]?, resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(index: index, suffix: "")
        transport.performHead(path: path, params:params, body: body){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    func typeExists(index: String, type: String,  params: [String: Any]?, body: [String: Any]?, resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(index: index, type: type, suffix: "")
        transport.performHead(path: path, params:params, body: body){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    func putMapping(index: String, type: String, mapping: [String: Any]?, body: [String: Any]?, resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(index: index, type: type, suffix: "_mapping")
        transport.performPut(path: path, params:mapping, body: body){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    func getMapping(index: String, type: String, params: [String: Any]?, body: [String: Any]?, resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(index: index, type: type, suffix: "_mapping")
        transport.performGet(path: path, params:params, body: body){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    func getFieldMapping(index: String, type: String, fields: String, params: [String: Any]?, body: [String: Any]?, resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(index: index, type: type, suffix: "_mapping/\(type)/field/\(fields)")
        transport.performGet(path: path, params: params, body: body){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    func aliasExists(index: String, alias: String, params: [String: Any]?, body: [String: Any]?, resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(index: index, suffix: "_alias/\(alias)")
        transport.performHead(path: path, params: params, body: body){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    func getAlias(index: String, alias: String, params: [String: Any]?, body: [String: Any]?, resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(index: index, suffix: "_alias/\(alias)")
        transport.performGet(path: path, params: params, body: body){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    func putAlias(index: String, alias: String, params: [String: Any]?, body: [String: Any]?, resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(index: index, suffix: "_alias/\(alias)")
        transport.performPut(path: path, params: params, body: body){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    func deleteAlias(index: String, alias: String, params: [String: Any]?, body: [String: Any]?, resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(index: index, suffix: "_alias/\(alias)")
        transport.performDelete(path: path, params: params, body: body){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    func putTemplate(name: String,  params: [String: Any]?, body: [String: Any]?, resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(suffix: "_template/\(name)")
        transport.performPut(path: path, params: params, body: body){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    func existsTemplate(name: String, params: [String: Any]?, body: [String: Any]?, resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(suffix: "_template/\(name)")
        transport.performHead(path: path, params: params, body: body){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    func getTemplate(name: String, params: [String: Any]?, body: [String: Any]?, resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(suffix: "_template/\(name)")
        transport.performGet(path: path, params: params, body: body){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    func deleteTemplate(name: String, params: [String: Any]?, body: [String: Any]?, resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(suffix: "_template/\(name)")
        transport.performDelete(path: path, params: params, body: body){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    func getSettings(index: String, params: [String: Any]?, body: [String: Any]?, resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(index: index, suffix: "_settings)")
        transport.performGet(path: path, params: params, body: body){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    func putSettings(index: String, params: [String: Any]?, body: [String: Any]?, resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(index: index, suffix: "_settings")
        transport.performPut(path: path, params: params, body: body){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    func stats(index: String, metric: String, params: [String: Any]?, body: [String: Any]?, resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(index: index, suffix: "_stats/\(metric)")
        transport.performGet(path: path, params: params, body: body){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    func segments(index: String, params: [String: Any]?, body: [String: Any]?, resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(index: index, suffix: "_segments")
        transport.performGet(path: path, params:params, body: body){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    func validateQuery(index: String, type: String, params: [String: Any]?, body: [String: Any]?, resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(index: index, type: type, suffix: "_validate/query")
        transport.performGet(path: path, params:params, body: body){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    func clearCache(index: String, params: [String: Any]?, body: [String: Any]?, resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(index: index, suffix: "_cache/clear")
        transport.performPost(path: path, params:params, body: body){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    func recovery(index: String, params: [String: Any]?, body: [String: Any]?, resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(index: index, suffix: "_recovery")
        transport.performGet(path: path, params:params, body: body){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    func upgrade(index: String, params: [String: Any]?, body: [String: Any]?, resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(index: index, suffix: "_upgrade")
        transport.performPost(path: path, params:params, body: body){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    func getUpgrade(index: String, params: [String: Any]?, body: [String: Any]?, resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(index: index, suffix: "_upgrade")
        transport.performGet(path: path, params:params, body: body){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    func flushSynced(index: String, params: [String: Any]?, body: [String: Any]?, resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(index: index, suffix: "_flush/synced")
        transport.performPost(path: path, params:params, body: body){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    func shardStores(index: String, params: [String: Any]?, body: [String: Any]?, resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(index: index, suffix: "_shard_stores")
        transport.performGet(path: path, params:params, body: body){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    
    func forceMerge(index: String, params: [String: Any]?, body: [String: Any]?, resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(index: index, suffix: "_forcemerge")
        transport.performPost(path: path, params:params, body: body){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    func shrink(index: String, target: String, params: [String: Any]?, body: [String: Any]?, resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(index: index, suffix: "_shrink/\(target)")
        transport.performPut(path: path, params:params, body: body){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    func rollover(index: String, alias: String, newIndex: String, params: [String: Any]?, body: [String: Any]?, resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(index: index, suffix: "\(alias)/_rollover/\(newIndex)")
        transport.performPost(path: path, params:params, body: body){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    internal func preparePath(index: String? = nil, type: String? = nil, suffix: String ) -> String{
        return self.getBasePath(index: index, type: type) + "/\(suffix)"
    }
    
    internal func getBasePath(index: String?, type: String?) -> String{
        var path = "/\(index!)"
        if type != nil && type != nil{
            path = path + "/\(type!)"
        }
        return path
    }
}
