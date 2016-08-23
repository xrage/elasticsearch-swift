//
//  main.swift
//  elasticsearch
//
//  Created by Dharmendra Verma on 07/08/16.
//  Copyright © 2016 Dharmendra Verma. All rights reserved.
//

import Foundation

var sema = DispatchSemaphore( value: 0 )
let es = Elasticsearch(hosts: ["http://elastic-staging.housing.com:9200"], index:"buy", type: "inventory")

let params = ["size": 1000, "_source": ["_id"]] as [String : Any]
es.search(query: params, resultCallback: {
    (status, resp) in
    print(resp)
    print(status)
    sema.signal()
})


sema.wait()



