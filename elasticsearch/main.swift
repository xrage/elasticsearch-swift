//
//  main.swift
//  elasticsearch
//
//  Created by Dharmendra Verma on 07/08/16.
//  Copyright © 2016 Dharmendra Verma. All rights reserved.
//

import Foundation

let es = Elasticsearch(hosts: ["http://elastic-staging.housing.com:9200"])

es.printer()

