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
    var index: String = ""
    var type: String?
    
    init (hosts:Array<String>, index:String, type:String?){
        self.transport.hosts = hosts
        self.transport.setConnections()
        self.index = index
        self.type = type
    }
    
    func getSegments(resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(suffix: "_segments")
        transport.performGet(path: path){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    func getSettings(resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(suffix: "_settings")
        transport.performGet(path: path){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    func refresh(resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(suffix: "_refresh")
        transport.performGet(path: path){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    func analyze(query: [String: Any]?, resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(suffix: "_analyze")
        transport.performGet(path: path, params: query){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    func create(resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(suffix: "")
        transport.performPost(path: path){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    func get(resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(suffix: "")
        transport.performGet(path: path){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    func open(resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(suffix: "_open")
        transport.performPost(path: path){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    
    func close(resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(suffix: "_close")
        transport.performPost(path: path){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    func delete(resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(suffix: "")
        transport.performDelete(path: path){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    func exists(resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(suffix: "")
        transport.performHead(path: path){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    func typeExists(resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(suffix: "", enableType: true)
        transport.performHead(path: path){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    func putMapping(mapping: [String: Any]?, resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(suffix: "_mapping")
        transport.performPut(path: path, params: mapping){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    func getMapping(resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(suffix: "_mapping")
        transport.performGet(path: path){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    func getFieldMapping(fields: String, resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(suffix: "_mapping")
        transport.performGet(path: path, params: ["field": fields]){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    func aliasExists(alias: String, resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(suffix: "_alias/\(alias)")
        transport.performHead(path: path){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    func getAlias(alias: String, resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(suffix: "_alias/\(alias)")
        transport.performGet(path: path){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    func putAlias(alias: String, resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(suffix: "_alias/\(alias)")
        transport.performPut(path: path){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    func deleteAlias(alias: String, resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(suffix: "_alias/\(alias)")
        transport.performDelete(path: path){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    
    
    
    
    
    
    
    
    func flush(resultCallback: @escaping (Int, Any?) -> ()) {
        let path = self.preparePath(suffix: "_flush")
        transport.performPost(path: path){
            status, resp in
            resultCallback(status, resp)
        }
    }
    
    
    
    
    
    
    

    internal func preparePath(suffix: String, enableType: Bool = false) -> String{
        return self.getBasePath(enableType: enableType) + "/\(suffix)"
    }
    
    internal func getBasePath(enableType: Bool) -> String{
        var path = "/\(self.index)"
        if self.type != nil && enableType{
            path = path + "/\(self.type!)"
        }
        return path
    }
}
